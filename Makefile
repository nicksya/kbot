#APP = $(shell basename $(shell git remote get-url origin) .git)
REGISTRY = docker.io
REPO = mykytakhomenko/kbot
VERSION = $(shell git describe --tags --abbrev=0)
TARGETOS = linux
TARGETARCH ?= amd64
TARGETPLATFORM = $(TARGETOS)/$(TARGETARCH)
# Multiplatform options
# TARGETPLATFORM = linux/amd64,linux/arm64

ifeq ($(TARGETOS),)
$(error TARGETOS is not set)
endif
ifeq ($(TARGETARCH),)
$(error TARGETARCH is not set)
endif

format:
	@echo "Formatting Go code..."
	@gofmt -s -w ./

install-lint:
	@which golangci-lint >/dev/null || (echo "Installing golangci-lint..." && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.6.1)

lint:
	@echo "Running linter..."
	@golangci-lint run ./...

test:
	@echo "Running tests..."
	@go test -v

get:
	@echo "Getting dependencies..."
	@go get

build: format get
	@echo "Building production version..."
	@CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X=github.com/nicksya/kbot/cmd.appVersion=${VERSION} -w -s"

image:
	@echo "Building Docker image..."
	@docker build . -t ${REGISTRY}/${REPO}:${VERSION}-${TARGETOS}-${TARGETARCH} --platform $(TARGETPLATFORM)

push:
	@echo "Pushing Docker image..."
	docker push ${REGISTRY}/${REPO}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf kbot
	@docker rmi ${REGISTRY}/${REPO}:${VERSION}-${TARGETOS}-${TARGETARCH} || true

help:
	@echo "Available targets:"
	@echo "  help     - Show this help message"
	@echo "  format   - Format Go code"
	@echo "  lint     - Run golangci-lint"
	@echo "  test     - Run tests"
	@echo "  get      - Get dependencies"
	@echo "  build    - Build the application"
	@echo "  image    - Build Docker image"
	@echo "  push     - Push Docker image to registry"
	@echo "  clean    - Clean build artifacts"
	@echo ""
	@echo "Configuration:"
	@echo "  TARGETOS   - Target OS (linux, darwin, windows) [$(TARGETOS)]"
	@echo "  TARGETARCH - Target architecture (amd64, arm64) [$(TARGETARCH)]"
	@echo "  REGISTRY	- Container registry to store image to (docker.io, ghcr.io) [$(REGISTRY)]"
	@echo "  REPO   	- Name of the repository in the registry [$(REPO)]"
	@echo "  CGO_ENABLED - Enable CGO (0 or 1) [$(CGO_ENABLED)]"
