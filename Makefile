ifneq (,$(wildcard ./.env))
	include .env
	export
endif

cmd-exists-%:
	@hash $(*) > /dev/null 2>&1 || \
		(echo "ERROR: '$(*)' must be installed and available on your PATH."; exit 1)

.PHONY: run
run: cmd-exists-go
	@go run cmd/main.go

lint-go: cmd-exists-golangci-lint
	@echo "Lint Go"
	@go mod tidy
	@gofumpt -l -w .
	@golangci-lint run --verbose --timeout 3000s

.PHONY: lint-shell
lint-shell: cmd-exists-shellcheck
	@echo "Lint Shell from /scripts"
	@shellcheck --source-path=.:scripts scripts/*.sh

.PHONY: lint-solidity
lint-solidity: cmd-exists-solhint
	@solhint $$(find internal/_contracts/src -name '*.sol')

.PHONY: lint
lint: lint-go lint-shell lint-solidity


.PHONY: build
build: cmd-exists-go
	GOOS=darwin GOARCH=amd64 go build -o bin/concord-darwin-amd64 ./cmd/main.go
	GOOS=linux GOARCH=amd64 go build -o bin/concord-linux-amd64 ./cmd/main.go
	GOOS=windows GOARCH=amd64 go build -o bin/concord-windows-amd64.exe ./cmd/main.go

.PHONY: soldev
soldev:
	@./scripts/init-soldev.sh