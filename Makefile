.PHONY: help lint lint/go lint/typos lint/md fmt fmt/go fmt/golangci-lint fmt/md run/mcp-gopls install/tools

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

## Format all source files
fmt: fmt/go fmt/golangci-lint fmt/md

fmt/go:
	@echo "Format Go source files"
	@go fmt ./...

fmt/golangci-lint:
	@echo "Auto-fix lint issues"
	@go tool -modfile=misc/golangci-lint-go.mod golangci-lint run ./... -c .golangci.yml --fix --timeout=5m --issues-exit-code=0

fmt/md:
	@echo "Format Markdown files"
	@go tool -modfile=misc/mdsmith-go.mod mdsmith fix || true

run/mcp-gopls:
	@echo "Run gopls MCP server"
	@go tool -modfile=misc/gopls-go.mod gopls mcp

install/tools:
	@echo "Downloading misc tool dependencies..."
	@for mod in misc/*-go.mod; do \
		echo "Processing $$mod..."; \
		go mod download -modfile="$$mod"; \
	done
