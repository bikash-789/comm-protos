# Environment variables
GOHOSTOS := $(shell go env GOHOSTOS)
GOPATH := $(shell go env GOPATH)
GOROOT := $(shell go env GOROOT)
VERSION := $(shell git describe --tags --always 2>/dev/null || echo "unknown")
GOVERSION := $(shell go version | cut -d " " -f 3 | cut -c 3-)
PROTO_PATH := .
GO_OUT_PATH := .
svc_dir := luminex

# Find proto files based on operating system
ifeq ($(GOHOSTOS), windows)
	Git_Bash=$(subst \,/,$(subst cmd\,bin\bash.exe,$(dir $(shell where git))))
	PROTO_FILES=$(shell $(Git_Bash) -c "find $(svc_dir) -name *.proto | grep -v third_party")
else
	PROTO_FILES=$(shell find $(svc_dir) -name "*.proto" | grep -v third_party)
endif

.PHONY: init

init:
	@echo "Installing required protobuf tools..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install github.com/go-kratos/kratos/cmd/protoc-gen-go-http/v2@latest
	go install github.com/google/gnostic/cmd/protoc-gen-openapi@latest
	go install github.com/go-kratos/kratos/cmd/protoc-gen-go-errors/v2@latest
	go install github.com/envoyproxy/protoc-gen-validate@latest
	@echo "Initialization completed."


# Generate Protocol Buffer files for specified service
api:
	@echo "Generating protobuf files in $(svc_dir)..."
	@if [ ! -d "$(svc_dir)" ]; then \
		echo "Directory $(svc_dir) does not exist."; \
		exit 1; \
	fi
	@if [ -z "$(PROTO_FILES)" ]; then \
		echo "No .proto files found in $(svc_dir)."; \
		exit 0; \
	fi
	protoc --proto_path=./ \
	       --proto_path=./third_party \
	       --go_out=paths=source_relative:./ \
	       --go-grpc_out=paths=source_relative:./ \
	       --validate_out=paths=source_relative,lang=go:./ \
	       --openapi_out=fq_schema_naming=true,default_response=false:$(svc_dir) \
	       $(PROTO_FILES)
	@echo "Protocol Buffer files for $(svc_dir) generated successfully."


clean:
	@echo "Cleaning generated protocol buffer files..."
	@find . -name "*.pb.go" -type f -delete
	@find . -name "*_pb2.py" -type f -delete
	@find . -name "*_pb2_grpc.py" -type f -delete
	@find . -name "*_pb2.pyi" -type f -delete
	@echo "Clean completed."


help:
	@echo ''
	@echo 'Usage:'
	@echo ' make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^# / { \
		helpMessage = substr($$0, 3); \
		getline; \
		if ($$0 ~ /^[a-zA-Z0-9_-]+:/) { \
			helpCommand = substr($$0, 0, index($$0, ":")); \
			printf "\033[36m%-20s\033[0m %s\n", helpCommand, helpMessage; \
		} \
	}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
