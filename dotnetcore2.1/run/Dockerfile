ARG TAG="latest"
FROM golang:1.12.9-stretch as builder

COPY commons/mocker /code

WORKDIR /code

RUN go mod download

RUN GOARCH=amd64 GOOS=linux go build -o mock main.go

FROM aliyunfc/runtime-dotnetcore2.1:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl https://fc-docker.oss-cn-shanghai.aliyuncs.com/dotnetcore2.1.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

RUN apt-get update \
  && apt-get install -y procps unzip --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

COPY dotnetcore2.1/run/agent.sh /var/fc/runtime/dotnetcore2.1/agent.sh

COPY --from=builder /code/mock /var/fc/runtime/dotnetcore2.1/mock

COPY dotnetcore2.1/run/vsdbg/GetVsDbg.sh /vsdbg/GetVsDbg.sh
RUN bash /vsdbg/GetVsDbg.sh -v latest -l /vsdbg
RUN apt-get purge -y unzip

COPY dotnetcore2.1/run/runtime /var/fc/runtime/dotnetcore2.1/bootstrap

COPY dotnetcore2.1/run/debugger /debugger
WORKDIR /debugger
RUN dotnet publish --configuration Release --output /debugger/output
RUN cp /debugger/output/Debugger.* /var/fc/runtime/dotnetcore2.1/bootstrap

WORKDIR /code

ENV AGENT_DIR=/var/fc/runtime/dotnetcore2.1 \
    AGENT_SCRIPT=agent.sh

ENTRYPOINT ["/var/fc/runtime/dotnetcore2.1/mock"]
