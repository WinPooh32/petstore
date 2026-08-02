.PHONY: help lint lint/go lint/typos lint/md fmt fmt/go

## Show available targets
help:
	@grep -E '^[a-zA-Z_/-]+:.*## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

## Run all linters
lint: lint/go lint/typos lint/md

lint/go:
	@echo "Run go linter"
	@go tool -modfile=misc/golangci-lint-go.mod golangci-lint run ./... -c .golangci.yml

lint/typos:
	@echo "Run typos linter"
	@typos

lint/md:
	@echo "Run markdown linter"
	@go tool -modfile=misc/mdsmith-go.mod mdsmith check

## Format Go source files
fmt: fmt/go

fmt/go:
	@echo "Format Go source files"
	@go fmt ./...

fmt/md:
	@echo "Format Markdown files"
	@go tool -modfile=misc/mdsmith-go.mod mdsmith fix || true
