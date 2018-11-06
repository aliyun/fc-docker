docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python2.7  index.handler
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python2.7  index.handler '{"key" : "value"}'

# Using short/long param
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python2.7 --handler "index.handler"
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python2.7 --handler "index.handler" --event '{"key" : "value"}'

# Using initializer feature.
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python2.7 --initializer "index.initializer" --handler "index.handler" --event '{"key" : "value"}'