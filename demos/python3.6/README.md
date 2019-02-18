
# Using short/long param
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python3.6 --handler "index.handler"
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python3.6 --handler "index.handler" --event '{"key" : "value"}'

# Using initializer feature.
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python3.6 --initializer "index.initializer" --handler "index.handler" --event '{"key" : "value"}'