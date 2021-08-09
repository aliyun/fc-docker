ARG TAG="latest"
FROM golang:1.12.9-stretch as builder

COPY commons/mocker /code

WORKDIR /code

# https://github.com/goproxy/goproxy.cn
ENV GOPROXY https://goproxy.io

RUN go mod download

RUN GOARCH=amd64 GOOS=linux go build -o mock main.go

FROM aliyunfc/runtime-dotnetcore2.1:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl https://aliyun-fc-docker.oss-cn-shanghai.aliyuncs.com/dotnetcore2.1.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

RUN apt-get update \
  && apt-get --no-install-recommends  install -y apt-utils ca-certificates procps unzip \
  && rm -rf /var/lib/apt/lists/*

COPY dotnetcore2.1/run/agent.sh /var/fc/runtime/dotnetcore2.1/agent.sh

COPY --from=builder /code/mock /var/fc/runtime/dotnetcore2.1/mock

COPY dotnetcore2.1/run/vsdbg/GetVsDbg.sh /vsdbg/GetVsDbg.sh
RUN bash /vsdbg/GetVsDbg.sh -v latest -l /vsdbg
RUN apt-get purge -y unzip

COPY dotnetcore2.1/run/runtime /var/fc/runtime/dotnetcore2.1/bootstrap
# fix the dotnetcore2.1's bug on System.Net.HttpListener.dll. Once it's offically released, remove it.
COPY commons/System.Net.HttpListener.dll /usr/share/dotnet/shared/Microsoft.NETCore.App/2.1.15

COPY dotnetcore2.1/run/debugger /debugger
WORKDIR /debugger
RUN dotnet publish --configuration Release --output /debugger/output
RUN cp /debugger/output/Debugger.* /var/fc/runtime/dotnetcore2.1/bootstrap


RUN apt-get update && apt-get install -y nfs-common --no-install-recommends && rm -r /var/lib/apt/lists/*

WORKDIR /code

ENV AGENT_DIR=/var/fc/runtime/dotnetcore2.1 \
  AGENT_SCRIPT=agent.sh

ENTRYPOINT ["/var/fc/runtime/dotnetcore2.1/mock"]
