using System;
using System.IO;
using System.Text;
using Microsoft.Extensions.Logging;

using Aliyun.Serverless.Core;

namespace dotnetcore2._1
{
    public class App
    {
        public int counter;
        public App()
        {
            this.counter = 0;
        }

        public static string StreamToString(Stream stream)
        {
            using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
            {
                return reader.ReadToEnd();
            }
        }

        public void Initialize(IFcContext context)
        { 
            ILogger logger = context.Logger;
            logger.LogInformation(String.Format("RequestID is {0} ", context.RequestId));
            this.counter = this.counter + 1;
        }
    
        public Stream HandleRequest(Stream input, IFcContext context)
        {
            ILogger logger = context.Logger;
            logger.LogInformation(String.Format("Event {0} ", StreamToString(input)));
            logger.LogInformation(String.Format("Context {0} ", Newtonsoft.Json.JsonConvert.SerializeObject(context)));
            logger.LogInformation(String.Format("Handle request {0} ", context.RequestId));
            this.counter = this.counter + 2;
            String counterString = String.Format("{0}", this.counter);
            byte[] data = Encoding.UTF8.GetBytes(counterString);
            MemoryStream output = new MemoryStream();
            output.Write(data, 0, data.Length);
            output.Flush();
            return output;
        }
    }


}
