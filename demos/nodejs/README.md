docker run --rm -it -v $(pwd):/code tanhe123/runtime-nodejs8 
docker run --rm -it -v $(pwd):/code tanhe123/runtime-nodejs8 index.handler
docker run --rm -it -v $(pwd):/code tanhe123/runtime-nodejs8 index.handler '{"key" : "value"}'
docker run --rm -it -e FC_ACCESS_KEY_ID=123 -e FC_ACCESS_KEY_SECRET=123 -v $(pwd):/code tanhe123/runtime-nodejs8
