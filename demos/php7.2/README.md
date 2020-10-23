# Using short/long param

```bash
docker run --rm -v $(pwd):/code --env-file ./env.list aliyunfc/runtime-php7.2 --handler "index.handler"
docker run --rm -v $(pwd):/code --env-file ./env.list aliyunfc/runtime-php7.2 --handler "index.handler" --event '{"key" : "value"}'
```

# Using initializer feature.

```bash
docker run --rm -v $(pwd):/code --env-file ./env.list aliyunfc/runtime-php7.2 --initializer "index.initializer" --handler "index.handler" --event '{"key" : "value"}'
```
