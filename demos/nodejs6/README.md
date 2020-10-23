# Using short/long param

```bash
docker run --rm -v $(pwd):/code --env-file ./env.list aliyunfc/runtime-nodejs6 --handler "index.handler"
docker run --rm -v $(pwd):/code --env-file ./env.list aliyunfc/runtime-nodejs6 --handler "index.handler" --event '{"key" : "value"}'
```

# Using initializer feature.

```bash
docker run --rm -v $(pwd):/code --env-file ./env.list aliyunfc/runtime-nodejs6 --initializer "index.initializer" --handler "index.handler" --event '{"key" : "value"}'
```
