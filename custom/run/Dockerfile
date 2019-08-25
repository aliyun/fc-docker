FROM golang:1.12.9-stretch as builder

COPY commons/mocker /code

WORKDIR /code

RUN go mod download

RUN GOARCH=amd64 GOOS=linux go build -o mock main.go

FROM aliyunfc/runtime-custom:base-1.5.8

RUN apt-get update \
  && apt-get install -y procps --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /code/mock /var/fc/runtime/custom/mock

ENTRYPOINT ["/var/fc/runtime/custom/mock"]
