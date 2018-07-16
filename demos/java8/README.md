mvn package

docker run --rm -v $(pwd)/target/java8-1.0.0.jar:/code/java8-1.0.0.jar aliyunfc/runtime-java8 examples.Hello::handleRequest

docker run --rm -e FC_ACCESS_KEY_ID=123 -e FC_ACCESS_KEY_SECRET=123 -v $(pwd)/target/java8-1.0.0.jar:/code/java8-1.0.0.jar aliyunfc/runtime-java8 examples.Hello::handleRequest