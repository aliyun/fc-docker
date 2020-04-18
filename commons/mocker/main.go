package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"time"

	"io/ioutil"

	"github.com/fatih/color"
	"github.com/google/uuid"
	"github.com/pbnjay/memory"
	flag "github.com/spf13/pflag"
)

var (
	handler               = flag.StringP("handler", "h", "", "function handler")
	timeout               = flag.String("timeout", "3", "function timeout")
	initializer           = flag.StringP("initializer", "i", "", "function initializer")
	initializationTimeout = flag.StringP("initializationTimeout", "e", "3", "function initializationTimeout")
	serverMode            = flag.Bool("server", false, "function server mode")
	event                 = flag.String("event", "", "function event")
	stdin                 = flag.Bool("stdin", false, "read function event from stdin")
	httpFlag              = flag.Bool("http", false, "used for a http trigger request")
	eventDecode           = flag.Bool("event-decode", false, "")
)

type HTTPParams struct {
	Path       string              `json:"path"`
	Method     string              `json:"method"`
	RequestURI string              `json:"requestURI"`
	ClientIP   string              `json:"clientIP"`
	HeadersMap map[string][]string `json:"headersMap"`
	QueriesMap map[string][]string `json:"queriesMap"`
	Host       string              `json:"host"`
}

func waitHostPortAvailable(hostport string) error {

	for {
		conn, _ := net.DialTimeout("tcp", hostport, time.Duration(10)*time.Minute)
		if conn != nil {
			return conn.Close()
		}

		time.Sleep(time.Duration(10) * time.Millisecond)
	}
}

const (
	serverPort = 9000
)

func checkError(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func min(x, y uint64) uint64 {
	if x < y {
		return x
	}
	return y
}

func queryMemoryLimit() string {
	limitInBytesFileContent, err := ioutil.ReadFile("/sys/fs/cgroup/memory/memory.limit_in_bytes")
	checkError(err)

	limitInBytes, _ := strconv.ParseUint(strings.TrimSpace(string(limitInBytesFileContent)), 10, 64)

	dockerMemoryLimit := limitInBytes / 1024 / 1024
	hostMemoryLimit := memory.TotalMemory() / 1024 / 1024

	memoryLimit := min(dockerMemoryLimit, hostMemoryLimit)

	return strconv.FormatUint(memoryLimit, 10)
}

func queryMemoryUsage() string {
	usageInBytesFileContent, err := ioutil.ReadFile("/sys/fs/cgroup/memory/memory.usage_in_bytes")
	checkError(err)

	usageInBytes, _ := strconv.ParseUint(strings.TrimSpace(string(usageInBytesFileContent)), 10, 64)

	usage := usageInBytes / 1024 / 1024

	return strconv.FormatUint(usage, 10)
}

func getRequestBody() []byte {
	var requestBody []byte

	if *stdin {
		stdin, err := ioutil.ReadAll(os.Stdin)
		checkError(err)

		return stdin
	} else {
		requestBody = []byte(*event)
	}

	if len(requestBody) == 0 {
		return requestBody
	}

	if *eventDecode {
		decodedEvent, err := base64.StdEncoding.DecodeString(*event)
		checkError(err)
		requestBody = decodedEvent
	} else {
		requestBody = []byte(requestBody)
	}

	return requestBody
}

func getEnv(key, fallback string) string {
	value := os.Getenv(key)
	if len(value) == 0 {
		return fallback
	}
	return value
}

func main() {
	color.NoColor = false

	flag.Parse()

	agentScript := getEnv("AGENT_SCRIPT", "bootstrap")
	agentDir := getEnv("AGENT_DIR", "/code")

	cmd := exec.Command("sh", "-c", fmt.Sprintf("ps aux | grep \"%s\"  | grep -q -v grep", agentScript))
	_, err := cmd.CombinedOutput()

	if err != nil {
		var agentExe *exec.Cmd

		// start process
		agentExe = exec.Command("sh", "-c", fmt.Sprintf("%s", agentDir + "/" + agentScript))
		agentExe.Stdout = os.Stdout
		agentExe.Stderr = os.Stderr

		err := agentExe.Start()
		checkError(err)

		if *serverMode {
			err = agentExe.Wait()
			checkError(err)
			return
		}
	}

	err = waitHostPortAvailable("127.0.0.1:9000")

	checkError(err)

	if (*initializer) != "" {
		request("/", "POST", "/initialize", nil)
	}

	requestBody := getRequestBody()

	if *httpFlag {
		request("/", "POST", "/http-invoke", requestBody)
	} else {
		request("/", "POST", "/invoke", requestBody)
	}
}

func convertToPlainResponse(resp *http.Response, body []byte) bytes.Buffer {
	var buffer bytes.Buffer

	fmt.Fprintf(&buffer, "%s %s\r\n", resp.Proto, resp.Status)
	resp.Header.Write(&buffer)

	buffer.WriteString("\r\n")
	buffer.Write(body)

	return buffer
}

func addFcReqHeaders(req *http.Request, reqeustId, controlPath string) {
	functionName := getEnv("FC_FUNCTION_NAME", "fc-docker")

	securityToken := os.Getenv("FC_SECURITY_TOKEN")
	accessKeyId := os.Getenv("FC_ACCESS_KEY_ID")
	accessKeySecret := os.Getenv("FC_ACCESS_KEY_SECRET")
	httpParams := os.Getenv("FC_HTTP_PARAMS")

	req.Header.Add("Content-Type", "application/octet-stream")
	req.Header.Add("x-fc-request-id", reqeustId)
	req.Header.Add("x-fc-function-name", functionName)
	req.Header.Add("x-fc-function-memory", queryMemoryLimit())
	req.Header.Add("x-fc-function-timeout", *timeout)
	req.Header.Add("x-fc-initialization-timeout", *initializationTimeout)
	req.Header.Add("x-fc-function-initializer", *initializer)
	req.Header.Add("x-fc-function-handler", *handler)
	req.Header.Add("x-fc-access-key-id", accessKeyId)
	req.Header.Add("x-fc-access-key-secret", accessKeySecret)
	req.Header.Add("x-fc-security-token", securityToken)
	req.Header.Add("x-fc-control-path", controlPath)
	req.Header.Add("x-fc-http-params", httpParams)
}

func updateHttpReqByHttpParams(req *http.Request) {
	encodedHttpParams := os.Getenv("FC_HTTP_PARAMS")

	var httpParams HTTPParams

	decodeBytes, err := base64.StdEncoding.DecodeString(encodedHttpParams)
	checkError(err)

	json.Unmarshal(decodeBytes, &httpParams)

	req.URL, err = url.Parse(fmt.Sprintf("http://localhost:%d%s", serverPort, httpParams.RequestURI))

	checkError(err)

	for k, vlist := range httpParams.HeadersMap {
		for _, v := range vlist {
			req.Header.Set(k, v)
		}
	}

	req.Method = httpParams.Method
	req.Host = httpParams.Host
}

func doRequest(req *http.Request) *http.Response {
	client := &http.Client{
		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			return http.ErrUseLastResponse
		},
	}

	resp, err := client.Do(req)
	checkError(err)

	return resp
}

func request(path, method, controlPath string, requestBody []byte) {
	startTime := time.Now().UnixNano()
	reqeustId := uuid.New().String()

	memoryLimit := queryMemoryLimit()

	req, err := http.NewRequest(method, fmt.Sprintf("http://localhost:%d%s", serverPort, path), nil)
	checkError(err)

	addFcReqHeaders(req, reqeustId, controlPath)

	if *httpFlag {
		updateHttpReqByHttpParams(req)
	}

	if requestBody != nil {
		req.Body = ioutil.NopCloser(bytes.NewReader(requestBody))
	}

	resp := doRequest(req)

	body, err := ioutil.ReadAll(resp.Body)
	checkError(err)
	defer resp.Body.Close()

	endTime := time.Now().UnixNano()
	billedTime := (endTime - startTime) / int64(time.Millisecond)

	if *httpFlag {
		responseBuffer := convertToPlainResponse(resp, body)

		fmt.Println("--------------------response begin-----------------")
		fmt.Println(base64.StdEncoding.EncodeToString([]byte(responseBuffer.Bytes())))
		fmt.Println("--------------------response end-----------------")

		fmt.Println("--------------------execution info begin-----------------")
		execInfo := fmt.Sprintf("%s\n%d\n%s\n%s", reqeustId, billedTime, memoryLimit, queryMemoryUsage())

		fmt.Println(base64.StdEncoding.EncodeToString([]byte(execInfo)))
		fmt.Println("--------------------execution info end-----------------")
	} else {
		fmt.Println(string(body))
	}
}
