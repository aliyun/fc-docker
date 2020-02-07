using System;
using System.Diagnostics;
using System.Threading.Tasks;

namespace Debugger
{
    public class DebuggerExtension
    {
        private static readonly TimeSpan DEBUGGER_STATUS_QUERY_INTERVAL = TimeSpan.FromMilliseconds(50);
        private static readonly TimeSpan DEBUGGER_STATUS_QUERT_TIMEOUT = TimeSpan.FromMinutes(10);

        public static void Run()
        {
            String debugOptions = Environment.GetEnvironmentVariable("DEBUG_OPTIONS");
            if (!String.IsNullOrEmpty(debugOptions))
            {
                Console.WriteLine("Waiting for the debugger to attach...");

                if (!WaitForAttaching(
                    DEBUGGER_STATUS_QUERY_INTERVAL,
                    DEBUGGER_STATUS_QUERT_TIMEOUT))
                {
                    Console.WriteLine("Timeout. Proceeding without debugger.");
                }
            }
        }

        public static bool WaitForAttaching(TimeSpan interval, TimeSpan timeout)
        {
            Stopwatch stopwatch = Stopwatch.StartNew();

            while (!System.Diagnostics.Debugger.IsAttached)
            {
                if (stopwatch.Elapsed > timeout)
                {
                    return false;
                }
                Task.Delay(interval).Wait();
            }
            return true;
        }
    }
}
