package com.aliyun.fc.runtime;

import com.aliyun.fc.runtime.Context;
import com.aliyun.fc.runtime.StreamRequestHandler;
import com.aliyun.oss.OSSClient;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Scanner;

public class DumpJava8 implements StreamRequestHandler {

    @Override
    public void handleRequest(InputStream inputStream, OutputStream outputStream, jdk.nashorn.internal.runtime.Context context) throws IOException {

        String filename = "java8.tgz";
        String bucketName = System.getenv("Bucket");
        String endpoint = System.getenv("OSSEndpoint");
        String source = String.format("/tmp/%s", filename);
        String target = String.format("%s", filename);

        String cmd = String.format("tar -cpzf %s --numeric-owner --ignore-failed-read /var/fc/runtime", source);

        Process process = Runtime.getRuntime().exec(new String[] { "sh", "-c", cmd });

        try (Scanner stdoutScanner = new Scanner(process.getInputStream());
             Scanner stderrScanner = new Scanner(process.getErrorStream())) {
            // Echo all stdout first
            while (stdoutScanner.hasNextLine()) {
                System.out.println(stdoutScanner.nextLine());
            }
            // Then echo stderr
            while (stderrScanner.hasNextLine()) {
                System.err.println(stderrScanner.nextLine());
            }
        }

        try {
            process.waitFor();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        if (process.exitValue() != 0) {
            return ;
        }

        context.getLogger().info("Zipping done! Uploading...");

        Credentials credentials = context.getExecutionCredentials();

        OSSClient ossClient = new OSSClient(endpoint,
                credentials.getAccessKeyId(),
                credentials.getAccessKeySecret(),
                credentials.getSecurityToken());

        ossClient.putObject(bucketName, target, new File(source));

        context.getLogger().info("Uploading done!");
        outputStream.write(new String("Zipping done and uploading done!").getBytes());
    }

    public static void main(String[] args) throws IOException {
        Credentials credentials = new Credentials() {
            @Override
            public String getAccessKeyId() {
                return "LTAI2l7G5O2Wr3Ra";
            }

            @Override
            public String getAccessKeySecret() {
                return "OjE4lLjgrpatD9ds0qD39ShMxYDA63";
            }

            @Override
            public String getSecurityToken() {
                return null;
            }
        };

        Context context = new Context() {
            @Override
            public String getRequestId() {
                return null;
            }

            @Override
            public Credentials getExecutionCredentials() {
                return credentials;
            }

            @Override
            public FunctionParam getFunctionParam() {
                return null;
            }

            @Override
            public FunctionComputeLogger getLogger() {
                return null;
            }
        };

        new DumpJava8().handleRequest(null, System.out, context);
    }
}