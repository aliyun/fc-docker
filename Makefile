.PHONY: login build build-push update-latest

IMAGE_PREFIX := sbox-

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

check-repo-env:
ifndef REPO
	$(error REPO is undefined)
endif

check-tag:
ifndef TRAVIS_TAG
	$(error TRAVIS_TAG is undefined)
endif

login:
	echo "$$DOCKER_PASS" | docker login -u $$DOCKER_USER --password-stdin

build: check-runtime-env check-variant-env check-repo-env check-tag
	cd $(DIR) && \
	docker build -t "$(IMAGE)" .

build-push: build login 
	docker push $(IMAGE)

update-latest: check-runtime-env check-variant-env check-repo-env login 
	LATEST_VERSION=$(shell (head -n 1 LATEST)); \
	if [ "run" != "$$VARIANT" ]; then DEST_TAG=build; SOURCE_TAG=build-$$LATEST_VERSION; else DEST_TAG=latest; SOURCE_TAG=$$LATEST_VERSION; fi; \
	docker pull $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG && \
	docker tag $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$SOURCE_TAG $(REPO)/$(RUNTIME):$$DEST_TAG && \
	docker push $(REPO)/$(IMAGE_PREFIX)$(RUNTIME):$$DEST_TAG