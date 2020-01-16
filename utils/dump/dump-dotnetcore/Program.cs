using System;
using System.IO;
using System.Diagnostics;
using Aliyun.OSS;
using Aliyun.Serverless.Core;

namespace dump_dotnetcore
{
    public class App
    {
        public string Handler(Stream input, IFcContext context)
        {
            String fileName = Environment.GetEnvironmentVariable("FileName");
            String source = $"/tmp/{fileName}";
            String dest = fileName;
            String cmd = $"tar -cpzf {source} --numeric-owner --ignore-failed-read /var/fc/runtime";

            var process = new Process()
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "/bin/bash",
                    Arguments = $"-c \"{cmd}\"",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true,
                }
            };
            process.Start();
            string result = process.StandardOutput.ReadToEnd();
            process.WaitForExit();

            OssClient ossClient = new OssClient(
                Environment.GetEnvironmentVariable("OSSEndpoint"),
                context.Credentials.AccessKeyId,
                context.Credentials.AccessKeySecret, 
                context.Credentials.SecurityToken
            );
            try
            {
                // 上传文件。
                ossClient.PutObject(
                    Environment.GetEnvironmentVariable("Bucket"),
                    dest,
                    source
                );
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            return result;
        }
    }
}
