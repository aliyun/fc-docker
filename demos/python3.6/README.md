docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python3.6
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python3.6 index.handler
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python3.6 index.handler '{"key" : "value"}'
