package examples;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Scanner;

import com.aliyun.fc.runtime.*;

public class Hello implements StreamRequestHandler, FunctionInitializer {
    public int counter;
    public Hello() {
        this.counter = 0;
    }

    @Override
    public void initialize(Context context) throws IOException {
        FunctionComputeLogger logger = context.getLogger();
        logger.debug(String.format("RequestID is %s %n", context.getRequestId()));
        this.counter = this.counter + 1;
    }
    @Override
    public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context) throws IOException {
        FunctionComputeLogger logger = context.getLogger();
        logger.debug(String.format("Handle request %s %n", context.getRequestId()));
        this.counter = this.counter + 2;
        String counterString = String.format("%d", this.counter);
        outputStream.write(new String(counterString).getBytes());
        outputStream.flush();
    }
}