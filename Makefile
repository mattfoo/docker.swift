DOCKER = docker

NAME     = swift
REGISTRY =
VERSION  = 2.2-SNAPSHOT-2016-02-08-a
BRANCH   = swift-2.2-branch

.PHONY: build clean

all: build

build:
		$(DOCKER) build --build-arg SWIFT_VERSION=$(VERSION) --build-arg SWIFT_BRANCH=$(BRANCH) --rm=true -t $(NAME):$(VERSION) .

clean:
		$(DOCKER) rmi $(NAME):$(VERSION)

default: build
