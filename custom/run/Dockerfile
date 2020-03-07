ARG TAG="latest"
FROM golang:1.12.9-stretch as builder

COPY commons/mocker /code

WORKDIR /code

RUN go mod download

RUN GOARCH=amd64 GOOS=linux go build -o mock main.go

FROM aliyunfc/runtime-custom:${TAG}

RUN apt-get update \
  && apt-get --no-install-recommends  install -y apt-utils ca-certificates procps \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /code/mock /var/fc/runtime/custom/mock

ENTRYPOINT ["/var/fc/runtime/custom/mock"]
