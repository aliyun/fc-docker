.PHONY: login build build-and-push update-latest

IMAGE_PREFIX ?= runtime-
REPO ?= aliyunfc

RUNTIMES ?= java8 nodejs4.4 nodejs6.10.3 nodejs8 python2.7 python3.6
VARIANTS ?= build

# build or empty
TAG_PREFIX := $(VARIANT:run%=%)

# build or empty or build-version or -version
WITH_VERSION := $(if $(TRAVIS_TAG),$(TAG_PREFIX)-$(TRAVIS_TAG),$(TAG_PREFIX))

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
ifndef TRAVIS_TAG
	$(error TRAVIS_TAG is undefined)
endif

login:
	echo "$$DOCKER_PASS" | docker login -u $$DOCKER_USER --password-stdin

build: check-runtime-env check-variant-env check-tag
	cd $(DIR) && \
	docker build -t "$(IMAGE)" .

build-and-push: build login 
	docker push $(IMAGE)

build-and-push-all: login
	for RUNTIME in $(RUNTIMES) ; do \
		for VARIANT in $(VARIANTS) ; do \
			make build-and-push RUNTIME=$$RUNTIME VARIANT=$$VARIANT TRAVIS_TAG=$$TRAVIS_TAG; \
		done \
	done 

update-latest: check-runtime-env check-variant-env login 
	LATEST_VERSION=$(shell (head -n 1 LATEST)); \
	if [ "run" != "$$VARIANT" ]; then DEST_TAG=build; SOURCE_TAG=build-$$LATEST_VERSION; else DEST_TAG=latest; SOURCE_TAG=$$LATEST_VERSION; fi; \
	docker pull $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG && \
	docker tag $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$DEST_TAG && \
	docker push $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$DEST_TAG

update-latest-all: login 
	for RUNTIME in $(RUNTIMES) ; do \
		for VARIANT in $(VARIANTS) ; do \
			make update-latest RUNTIME=$$RUNTIME VARIANT=$$VARIANT; \
		done \
	done 