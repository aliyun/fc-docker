
build:
	docker build -t aliyunfc/fc-runtime:java8-stretch-base -f Dockerfile.java8-stretch-base .
	docker build -t aliyunfc/fc-runtime:java11-stretch-base -f Dockerfile.java11-stretch-base .
	docker build -t aliyunfc/fc-runtime:python36-stretch-base -f Dockerfile.python36stretch-base .
	docker build -t aliyunfc/fc-runtime:python39-stretch-base -f Dockerfile.python39stretch-base .
	docker build -t aliyunfc/fc-runtime:python27-stretch-base -f Dockerfile.python27stretch-base .
	docker build -t aliyunfc/fc-runtime:php7.2-stretch-base -f Dockerfile.php7.2-stretch-base .

push:
	docker push aliyunfc/fc-runtime:java8-stretch-base
	docker push aliyunfc/fc-runtime:java11-stretch-base
	docker push aliyunfc/fc-runtime:python36-stretch-base
	docker push aliyunfc/fc-runtime:python39-stretch-base
	docker push aliyunfc/fc-runtime:python27-stretch-base
	docker push aliyunfc/fc-runtime:php7.2-stretch-base

build-and-push-jessie:
	docker build -t aliyunfc/fc-runtime:jessie -f Dockerfile.jessie-base .
	docker push aliyunfc/fc-runtime:jessie

build-and-push-stretch:
	docker build -t aliyunfc/fc-runtime:stretch-base -f Dockerfile.stretch-base .
	docker push aliyunfc/fc-runtime:stretch-base

build-and-push:
	make build
	make push