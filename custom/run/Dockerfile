ARG TAG="latest"
FROM golang:1.12.9-stretch as builder

COPY commons/mocker /code

WORKDIR /code

# https://github.com/goproxy/goproxy.cn
ENV GOPROXY https://goproxy.io

RUN go mod download

RUN GOARCH=amd64 GOOS=linux go build -o mock main.go

FROM aliyunfc/runtime-custom:${TAG}

COPY --from=builder /code/mock /var/fc/runtime/custom/mock

ENTRYPOINT ["/var/fc/runtime/custom/mock"]
