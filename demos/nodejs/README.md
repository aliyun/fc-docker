docker run --rm -it -v $(pwd):/code aliyunfc/runtime-nodejs8 
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-nodejs8 index.handler
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-nodejs8 index.handler '{"key" : "value"}'
docker run --rm -it -e FC_ACCESS_KEY_ID=xxxxx -e FC_ACCESS_KEY_SECRET=xxxxx -v $(pwd):/code aliyunfc/runtime-nodejs8
