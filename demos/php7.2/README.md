
# Using short/long param
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-php7.2 --handler "index.handler"
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-php7.2 --handler "index.handler" --event '{"key" : "value"}'

# Using initializer feature.
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-php7.2 --initializer "index.initializer" --handler "index.handler" --event '{"key" : "value"}'