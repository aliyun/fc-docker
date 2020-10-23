```bash
# 本地是 jdk11
mvn package

docker run --rm -v $(pwd)/target/java11-1.0.0.jar:/code/java11-1.0.0.jar  --env-file ./env.list aliyunfc/runtime-java11 --handler "examples.Hello::handleRequest"

docker run --rm -v $(pwd)/target/java11-1.0.0.jar:/code/java11-1.0.0.jar --env-file ./env.list aliyunfc/runtime-java11 --handler "examples.Hello::handleRequest"
```
