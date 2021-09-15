.PHONY: login build build-and-push update-latest

SHELL = /bin/bash
.SHELLFLAGS = -ec

IMAGE_PREFIX ?= runtime-
REPO ?= aliyunfc

RUNTIMES ?= java8 java11 nodejs6 nodejs8 nodejs10 nodejs12 python2.7 python3.6 php7.2 dotnetcore2.1 custom
VARIANTS ?= base build run

FUN_VERSION ?= v3.6.20
FCLI_VERSION ?= v1.0.4
FUN_INSTALL_VERSION ?= v0.15.4

# build or empty
TAG_PREFIX := $(VARIANT:run%=%)

# build or empty or build-version or -version
WITH_VERSION := $(if $(TAG),$(TAG_PREFIX)-$(TAG),$(TAG_PREFIX))

# build or empty or build-version or version
IMAGE_TAG_WITHOUT_HYPHEN := $(WITH_VERSION:-%=%)

IMAGE_TAG := $(if $(IMAGE_TAG_WITHOUT_HYPHEN),:$(IMAGE_TAG_WITHOUT_HYPHEN),$(IMAGE_TAG_WITHOUT_HYPHEN))

IMAGE := $(REPO)/$(IMAGE_PREFIX)$(RUNTIME)$(IMAGE_TAG)

DIR := $(RUNTIME)$(if $(VARIANT),/$(VARIANT))

BUILD_ARG_TAG := $(if $(TAG),base-$(TAG),base)

check-runtime-env:
ifndef RUNTIME
	$(error RUNTIME is undefined)
endif

check-variant-env:
ifndef VARIANT
	$(error VARIANT is undefined)
endif

check-tag:
ifndef TAG
	$(error TAG is undefined)
endif

login:
	@if [ -n "$(DOCKER_PASS)" ] && [ -n "$(DOCKER_USER)" ]; then \
		if [ -n "$(REGISTRY)" ]; then \
			echo "$(ALIYUN_DOCKER_PASS)" | docker login -u $(ALIYUN_DOCKER_USER) --password-stdin $(REGISTRY); \
		else \
			echo "$(DOCKER_PASS)" | docker login -u $(DOCKER_USER) --password-stdin; \
		fi \
	else \
		if ! grep -q "index.docker.io" ~/.docker/config.json; then \
			echo "you must provide DOCKER_USER and DOCKER_PASS for docker login."; \
			exit 1; \
		fi; \
	fi; 

build: check-runtime-env 
	@if [ -n "$(VARIANT)" ]; then \
		echo "docker build -f \"$(DIR)/Dockerfile\" -t \"$(IMAGE)\" --build-arg TAG=$(BUILD_ARG_TAG) --build-arg FUN_VERSION=${FUN_VERSION} --build-arg FCLI_VERSION=${FCLI_VERSION} --build-arg FUN_INSTALL_VERSION=${FUN_INSTALL_VERSION} ."; \
		if ! docker build -f "$(DIR)/Dockerfile" -t "$(IMAGE)" --build-arg TAG=$(BUILD_ARG_TAG) --build-arg FUN_VERSION=${FUN_VERSION} --build-arg FCLI_VERSION=${FCLI_VERSION} --build-arg FUN_INSTALL_VERSION=${FUN_INSTALL_VERSION}  .; then \
			exit 1; \
		fi \
	else \
		for VARIANT in "base" "build" "run" ; do \
			make build RUNTIME=$(RUNTIME) VARIANT=$$VARIANT TAG=$$TAG || exit 1; \
		done \
	fi;

test: check-runtime-env
	IMAGE=$(IMAGE) RUNTIME=$(RUNTIME) ./test.sh 

test-all:
	@for RUNTIME in $(RUNTIMES) ; do \
		make test RUNTIME=$$RUNTIME VARIANT=run TAG=$$TAG; || exit 1; \
	done 

build-all:
	@for RUNTIME in $(RUNTIMES) ; do \
		for VARIANT in $(VARIANTS) ; do \
			make build RUNTIME=$$RUNTIME VARIANT=$$VARIANT TAG=$$TAG || exit 1; \
		done; \
	done 

push: check-runtime-env login
	@if [ -n "$(VARIANT)" ]; then \
		echo "docker push $(IMAGE)"; \
		if [ -n "$(REGISTRY)" ]; then \
			docker tag $(IMAGE) $(REGISTRY)/$(IMAGE) && \
			docker push $(REGISTRY)/$(IMAGE); \
		else \
			docker push $(IMAGE); \
		fi \
	else \
		for VARIANT in "base" "build" "run" ; do \
			make push RUNTIME=$$RUNTIME VARIANT=$$VARIANT TAG=$$TAG; \
		done \
	fi;

push-all:
	for RUNTIME in $(RUNTIMES) ; do \
		for VARIANT in $(VARIANTS) ; do \
			make push RUNTIME=$$RUNTIME VARIANT=$$VARIANT TAG=$$TAG; \
		done \
	done 

build-push: login build push

build-push-all: login build-all push-all

update-latest: check-runtime-env login 
	@if [ -n "$(VARIANT)" ]; then \
		LATEST_VERSION=$(shell (head -n 1 LATEST)); \
		if [ "run" != "$$VARIANT" ]; then DEST_TAG=$$VARIANT; SOURCE_TAG=$$VARIANT-$$LATEST_VERSION; else DEST_TAG=latest; SOURCE_TAG=$$LATEST_VERSION; fi; \
		if docker pull $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG; then \
			if [ -n "$(REGISTRY)" ] ; then \
				docker pull $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG && \
				docker tag $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG $(REGISTRY)/$(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$DEST_TAG && \
				docker push $(REGISTRY)/$(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$DEST_TAG; \
			else \
				docker pull $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG && \
				docker tag $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$DEST_TAG && \
				docker push $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$DEST_TAG; \
			fi \
		fi; \
	else \
		for VARIANT in "base" "build" "run" ; do \
			make update-latest RUNTIME=$$RUNTIME VARIANT=$$VARIANT TAG=$$TAG; \
		done \
	fi;


update-latest-all: login 
	@for RUNTIME in $(RUNTIMES) ; do \
		for VARIANT in $(VARIANTS) ; do \
			make update-latest RUNTIME=$$RUNTIME VARIANT=$$VARIANT; \
		done \
	done 
