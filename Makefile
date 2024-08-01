REGISTRY_NAME?=docker.io/iejalapeno
IMAGE_VERSION?=latest

.PHONY: all igp-processor container push clean test

ifdef V
TESTARGS = -v -args -alsologtostderr -v 5
else
TESTARGS =
endif

all: igp-processor

igp-processor:
	mkdir -p bin
	$(MAKE) -C ./cmd compile-igp-processor

igp-processor-container: igp-processor
	docker build -t $(REGISTRY_NAME)/igp-processor:$(IMAGE_VERSION) -f ./build/Dockerfile.igp-processor .

push: igp-processor-container
	docker push $(REGISTRY_NAME)/igp-processor:$(IMAGE_VERSION)

clean:
	rm -rf bin

test:
	GO111MODULE=on go test `go list ./... | grep -v 'vendor'` $(TESTARGS)
	GO111MODULE=on go vet `go list ./... | grep -v vendor`
