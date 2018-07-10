package examples;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Scanner;

import com.aliyun.fc.runtime.*;


public class Hello implements StreamRequestHandler {

    @Override
    public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context) throws IOException {
        Credentials creds = context.getExecutionCredentials();
        
        outputStream.write(new String(creds.toString() + '\n').getBytes());
        outputStream.write(new String("accessKeyId: " + creds.getAccessKeyId() + " accessSecretKey: " + creds.getAccessKeySecret() + "\n").getBytes());
        outputStream.write(new String("hello world\n").getBytes());
    }
}