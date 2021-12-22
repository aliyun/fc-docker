build:
	docker build -t aliyunfc/fc-runtime:jessie -f Dockerfile.jessie-base .
	docker build -t aliyunfc/fc-runtime:stretch-base -f Dockerfile.stretch-base .
	docker build -t aliyunfc/fc-runtime:java8-stretch-base -f Dockerfile.java8-stretch-base .

push:
	docker push aliyunfc/fc-runtime:jessie
	docker push aliyunfc/fc-runtime:stretch-base
	docker push aliyunfc/fc-runtime:java8-stretch-base