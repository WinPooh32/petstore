.PHONY: help lint lint/go lint/typos lint/gomarklint

## Show available targets
help:
	@grep -E '^[a-zA-Z_/-]+:.*## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

## Run all linters
lint: lint/go lint/typos lint/gomarklint

lint/go:
	@echo "Run go linter"
	@go tool -modfile=misc/golangci-lint-go.mod golangci-lint run ./... -c .golangci.yml

lint/typos:
	@echo "Run typos linter"
	@typos

lint/gomarklint:
	@echo "Run markdown linter"
	@go tool -modfile=misc/gomarklint-go.mod gomarklint
