## fc-docker

[![Build Status](https://travis-ci.org/aliyun/fc-docker.svg?branch=master)](https://travis-ci.org/aliyun/fc-docker)

FC Docker is a complete emulation of the actual function runtimes. It helps you to develop, build, run, debug, test and deploy function locally. The function execution results be the same as the ones executed in the cloud.

![fc docker nodejs6](./figures/fc-docker-nodejs6.png)

All the programming language runtimes excluding the deprecated language versions are supported, see the following table:

| Runtime                                                                       | Image                                                                                                                                                                                                                                                                                               |
| ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [nodejs6](https://hub.docker.com/r/aliyunfc/runtime-nodejs6/tags)             | ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-nodejs6?label=image%20size) ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-nodejs6/build?label=build%20image%20size) ![](https://img.shields.io/docker/pulls/aliyunfc/runtime-nodejs6.svg)                   |
| [nodejs8](https://hub.docker.com/r/aliyunfc/runtime-nodejs8/tags)             | ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-nodejs8?label=image%20size) ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-nodejs8/build?label=build%20image%20size) ![](https://img.shields.io/docker/pulls/aliyunfc/runtime-nodejs8.svg)                   |
| [nodejs10](https://hub.docker.com/r/aliyunfc/runtime-nodejs10/tags)           | ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-nodejs10?label=image%20size) ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-nodejs10/build?label=build%20image%20size) ![](https://img.shields.io/docker/pulls/aliyunfc/runtime-nodejs10.svg)                |
| [nodejs12](https://hub.docker.com/r/aliyunfc/runtime-nodejs12/tags)           | ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-nodejs10?label=image%20size) ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-nodejs10/build?label=build%20image%20size) ![](https://img.shields.io/docker/pulls/aliyunfc/runtime-nodejs12.svg)                |
| [python2.7](https://hub.docker.com/r/aliyunfc/runtime-python2.7/tags)         | ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-python2.7?label=image%20size) ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-python2.7/build?label=build%20image%20size) ![](https://img.shields.io/docker/pulls/aliyunfc/runtime-python2.7.svg)             |
| [python3.6](https://hub.docker.com/r/aliyunfc/runtime-python3.6/tags)         | ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-python3.6?label=image%20size) ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-python3.6/build?label=build%20image%20size) ![](https://img.shields.io/docker/pulls/aliyunfc/runtime-python3.6.svg)             |
| [java8](https://hub.docker.com/r/aliyunfc/runtime-java8/tags)                 | ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-java8?label=image%20size) ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-java8/build?label=build%20image%20size) ![](https://img.shields.io/docker/pulls/aliyunfc/runtime-java8.svg)                         |
| [php7.2](https://hub.docker.com/r/aliyunfc/runtime-php7.2/tags)               | ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-php7.2?label=image%20size) ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-php7.2/build?label=build%20image%20size) ![](https://img.shields.io/docker/pulls/aliyunfc/runtime-php7.2.svg)                      |
| [dotnetcore2.1](https://hub.docker.com/r/aliyunfc/runtime-dotnetcore2.1/tags) | ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-dotnetcore2.1?label=image%20size) ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-dotnetcore2.1/build?label=build%20image%20size) ![](https://img.shields.io/docker/pulls/aliyunfc/runtime-dotnetcore2.1.svg) |
| [custom](https://hub.docker.com/r/aliyunfc/runtime-custom/tags)               | ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-custom?label=image%20size) ![](https://img.shields.io/microbadger/image-size/aliyunfc/runtime-custom/build?label=build%20image%20size) ![](https://img.shields.io/docker/pulls/aliyunfc/runtime-custom.svg)                      |

In addition to locally execute your function, this project also include the Docker images to build locally. The common tools added include gcc, g++, npm, maven and pip etc.

Note：[Fun](https://github.com/aliyun/fun) fc-docker has been integrated into the funcraft tool, which provides better and more integrated development experience. We recommend to start with Funcraft.

## Prerequisites

Please install [Docker](https://www.docker.com/) first.

## Tutorials

Follow the instruction for each programming language：

```shell

# change directory to demos/nodejs6, demos/nodejs8, demos/nodejs10 or demos/nodejs12, execute the following command:
docker run --rm -v $(pwd):/code --env-file ./env.list aliyunfc/runtime-nodejs6 --handler "index.handler" --event '{"key" : "value"}'

# change directory to demos/python2.7, execute the following command:
docker run --rm -v $(pwd):/code --env-file ./env.list aliyunfc/runtime-python2.7 --handler "index.handler" --event '{"some": "event"}'

# change directory to demos/python3.6, execute the following command:
docker run --rm -v $(pwd):/code --env-file ./env.list aliyunfc/runtime-python3.6 --handler "index.handler" --event '{"some": "event"}'

# change directory to demos/php7.2, execute the following command:
docker run --rm -v $(pwd):/code --env-file ./env.list aliyunfc/runtime-php7.2 --handler "index.handler" --event '{"some": "event"}'

# change directory to demos/java8, execute the following command:
docker run -v $(pwd)/target/java8-1.0.0.jar:/code/java8-1.0.0.jar --env-file ./env.list aliyunfc/runtime-java8 --handler "examples.Hello::handleRequest"

```

More supported options

| Short-form |        Full-form        |                        Options description |
| :--------- | :---------------------: | -----------------------------------------: |
| -h         |        --handler        |                           Function handler |
| NA         |        --timeout        |               Function timeout, in seconds |
| -i         |      --initializer      |            Function initialization handler |
| -e         | --initializationTimeout | Function initialization timeout, in second |
| NA         |         --event         |         Function payload (input), in bytes |
| NA         |         --stdin         |          Enter function payload from stdin |
| NA         |        --server         |                                server mode |

Build function ZIP packages using the images：

```shell
# Download and install Nodejs dependencies (npm rebuild)
docker run --rm -v $(pwd):/code aliyunfc/runtime-nodejs6:build

# Executing commands inside the build container
docker run --rm -v $(pwd):/code aliyunfc/runtime-python2.7:build fun
docker run --rm -v $(pwd):/code aliyunfc/runtime-python3.6:build fcli

# Using interactive bash shell inside the build container
docker run --rm -it -v $(pwd):/code aliyunfc/runtime-python2.7:build bash
```

## Environment variables

fc-docker supports providing FC reserved environment variables to emulate local environment to match that of the cloud:

- FC_ACCESS_KEY_ID
- FC_ACCESS_KEY_SECRET
- FC_SECURITY_TOKEN
- FC_FUNCTION_NAME

Use the following command to set environment variables:

```shell
docker run --rm -it -e FC_ACCESS_KEY_ID=xxxxxxx -e FC_ACCESS_KEY_SECRET=xxxxxxxx -v $(pwd):/code nodejs6
```

## Dependencies pre-installed in build images

- fcli
- fun
- vim
- zip
- git
- build-essential
- clang
- libgmp3-dev
- python2.7-dev
- apt-utils
- dialog
