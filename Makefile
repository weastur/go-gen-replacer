.PHONY: help build clean tests unit-tests unit-tests-cov version
.DEFAULT_GOAL := help

BINARY_NAME=replacer
BIN_DIR=./bin
DIST_DIR=./dist
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

build: ## Build the binary
	@mkdir -p $(BIN_DIR)
	CGO_ENABLED=0 go build -tags netgo,static_build,osusergo,feature -ldflags "-extldflags "-static" -X github.com/weastur/go-gen-replacer/cmd/replacer.version=v0.0.0-dev0" -gcflags=all="-N -l" -o $(BIN_DIR)/$(BINARY_NAME)

clean: ## Cleanup
	@rm -rf $(DIST_DIR)
	@rm -rf $(BIN_DIR)

tests: unit-tests ## Run all tests

unit-tests: ## Run unit tests
	go test -v ./...

unit-tests-cov: ## Run unit tests with coverage
	go test -v -coverpkg=./pkg -coverprofile=coverage.txt ./...

version: ## Create new version. Bump, tag, commit, create tag
	@bump-my-version bump --verbose $(filter-out $@,$(MAKECMDGOALS))

%:
	@:

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
