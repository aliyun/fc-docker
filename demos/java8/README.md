```bash
# 本地是 jdk8
mvn package

docker run --rm -v $(pwd)/target/java8-1.0.0.jar:/code/java8-1.0.0.jar  --env-file ./env.list aliyunfc/runtime-java8 --handler "examples.Hello::handleRequest"

docker run --rm -v $(pwd)/target/java8-1.0.0.jar:/code/java8-1.0.0.jar --env-file ./env.list aliyunfc/runtime-java8 --handler "examples.Hello::handleRequest"
```
