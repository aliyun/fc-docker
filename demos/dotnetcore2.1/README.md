
# Using short/long param
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-dotnetcore2.1 --handler "dotnetcore2.1::dotnetcore2._1.App::HandleRequest"

docker run --rm -it -v $(pwd):/code aliyunfc/runtime-dotnetcore2.1 --handler "dotnetcore2.1::dotnetcore2._1.App::HandleRequest" --event '{"key" : "value"}'

docker run --rm -it -e FC_ACCESS_KEY_ID=xxxxx -e FC_ACCESS_KEY_SECRET=xxxxx -v $(pwd):/code aliyunfc/runtime-dotnetcore2.1 --handler "dotnetcore2.1::dotnetcore2._1.App::HandleRequest" --event '{"key" : "value"}'

# Using initializer feature.
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-dotnetcore2.1 --handler "dotnetcore2.1::dotnetcore2._1.App::HandleRequest" --initializer "dotnetcore2.1::dotnetcore2._1.App::Initialize"

docker run --rm -it -v $(pwd):/code aliyunfc/runtime-nodejs6 --initializer "index.initializer" --handler "index.handler" --event '{"key" : "value"}'