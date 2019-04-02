.PHONY: login build build-and-push update-latest

SHELL = /bin/bash
.SHELLFLAGS = -ec

IMAGE_PREFIX ?= runtime-
REPO ?= aliyunfc

RUNTIMES ?= java8 nodejs6 nodejs8 python2.7 python3.6 php7.2
VARIANTS ?= base build run

# build or empty
TAG_PREFIX := $(VARIANT:run%=%)

# build or empty or build-version or -version
WITH_VERSION := $(if $(TAG),$(TAG_PREFIX)-$(TAG),$(TAG_PREFIX))

# build or empty or build-version or version
IMAGE_TAG_WITHOUT_HYPHEN := $(WITH_VERSION:-%=%)

IMAGE_TAG := $(if $(IMAGE_TAG_WITHOUT_HYPHEN),:$(IMAGE_TAG_WITHOUT_HYPHEN),$(IMAGE_TAG_WITHOUT_HYPHEN))

IMAGE := $(REPO)/$(IMAGE_PREFIX)$(RUNTIME)$(IMAGE_TAG)

DIR := $(RUNTIME)$(if $(VARIANT),/$(VARIANT))

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
		echo "$(DOCKER_PASS)" | docker login -u $(DOCKER_USER) --password-stdin; \
	else \
		if ! grep -q "index.docker.io" ~/.docker/config.json; then \
			echo "you must provide DOCKER_USER and DOCKER_PASS for docker login."; \
			exit 1; \
		fi; \
	fi; 

build: check-runtime-env 
	@if [ -n "$(VARIANT)" ]; then \
		if ! docker build -f "$(DIR)/Dockerfile" -t "$(IMAGE)" .; then \
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
		docker push $(IMAGE); \
	else \
		for VARIANT in "base" "build" "run" ; do \
			make push RUNTIME=$$RUNTIME VARIANT=$$VARIANT TAG=$$TAG; \
		done \
	fi;

push-all:
	@for RUNTIME in $(RUNTIMES) ; do \
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
			docker pull $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG && \
			docker tag $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$DEST_TAG && \
			docker push $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$DEST_TAG; \
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