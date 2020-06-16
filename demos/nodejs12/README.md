
# Using short/long param
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-nodejs12 --handler "index.handler"
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-nodejs12 --handler "index.handler" --event '{"key" : "value"}'
docker run --rm -it -e FC_ACCESS_KEY_ID=xxxxx -e FC_ACCESS_KEY_SECRET=xxxxx -v $(pwd):/code aliyunfc/runtime-nodejs12

# Using initializer feature.
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-nodejs12 --initializer "index.initializer" --handler "index.handler" --event '{"key" : "value"}'