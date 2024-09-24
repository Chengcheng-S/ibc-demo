SHELL=/bin/bash
all:
	@make help


.PHONY: help ## Display help commands
help:
	@printf 'Usage:\n'
	@printf '  make <tagert>\n'
	@printf '\n'
	@printf 'Targets:\n'
	@IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
    for help_line in $${help_lines[@]}; do \
        IFS=$$'#' ; \
        help_split=($$help_line) ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		IFS=$$':' ; \
		phony_command=($$help_split); \
        help_command=`echo $${phony_command[1]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf "  %-50s %s\n" $$help_command $$help_info ; \
    done


.PHONY:goget  ## Run go get for all apps.
goget:
	@echo Running go get $(REPO)...
	@for dir in $$(find $$(pwd -P) -mindepth 1 -maxdepth 4 -type d); do \
        if [ -e "$$dir/go.mod" ]; then \
            echo "Running go get $(REPO) in $$dir"; \
            cd "$$dir" && go get $(REPO); \
        fi \
    done

.PHONY:modtidy  ## Run go mod tidy for all apps.
modtidy:
	@echo Running go mod tidy...
	@for dir in $$(find $$(pwd -P) -mindepth 1 -maxdepth 4 -type d); do \
        if [ -e "$$dir/go.mod" ]; then \
            echo "Running go mod tidy in $$dir"; \
            cd "$$dir" && go mod tidy; \
        fi \
    done


.PHONY: govulncheck ## Run govulncheck for all apps.
govulncheck:
	@command -v govulncheck >/dev/null 2>&1 || { \
        echo "Installing govulncheck..."; \
        go install golang.org/x/vuln/cmd/govulncheck@latest; \
    }
	@for dir in $$(find $$(pwd -P) -mindepth 1 -maxdepth 4 -type d); do \
        if [ -e "$$dir/go.mod" ]; then \
            echo "Running go vet in $$dir"; \
            cd "$$dir" && govulncheck ./...; \
        fi \
    done
	@echo Running govulncheck...

.PHONY: lint ## Run Golang Lint for all apps.
lint:
	@command -v golangci-lint >/dev/null 2>&1 || { \
        echo "Installing golangci-lint..."; \
        curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(shell go env GOPATH)/bin v1.60.3; \
    }
	@echo Running golangci-lint...
	@for dir in $$(find $$(pwd -P) -mindepth 1 -maxdepth 4 -type d); do \
        if [ -e "$$dir/go.mod" ]; then \
            echo "Running golangci-lint in $$dir"; \
            cd "$$dir" && golangci-lint run; \
        fi \
    done

.PHONY : lint-ci ## Run Golang CI Lint for all apps.
lint-ci:
	@command -v golangci-lint >/dev/null 2>&1 || { \
        echo "Installing golangci-lint..."; \
        curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(shell go env GOPATH)/bin v1.60.3; \
    }
	@echo Running golangci-lint...
	@for dir in $$(find $$(pwd -P) -mindepth 1 -maxdepth 4 -type d); do \
        if [ -e "$$dir/go.mod" ]; then \
            echo "Running golangci-lint in $$dir"; \
            cd "$$dir" && golangci-lint run --out-format=tab --issues-exit-code=0; \
        fi \
    done

# build
.PHONY: build ## build
build:
	cd ./cmd/planted && go build -o ../../build

# clean
.PHONY: clean ## clean
clean:
	rm -rf ./build/loand


.PHONY: govet ## Run go vet for all apps.
govet:
	@echo Running go vet...
	@for dir in $$(find $$(pwd -P) -mindepth 1 -maxdepth 4 -type d); do \
        if [ -e "$$dir/go.mod" ]; then \
            echo "Running go vet in $$dir"; \
            cd "$$dir" && go vet ./...; \
        fi \
    done


.PHONY: format ##Install and run goimports and gofumpt for all apps.
format:
	@echo Formatting...
	@command -v gofumpt >/dev/null 2>&1 || { \
        echo "Installing gofumpt..."; \
        go install mvdan.cc/gofumpt@latest; \
    }
	@command -v goimports >/dev/null 2>&1 || { \
        echo "Installing goimports..."; \
        go install golang.org/x/tools/cmd/goimports@latest; \
    }
	@for dir in $$(find $$(pwd -P) -mindepth 1 -maxdepth 4 -type d); do \
		if [ -e "$$dir/go.mod" ]; then \
			echo "Running format in $$dir"; \
			cd "$$dir" && gofumpt -w .; \
			cd "$$dir" && goimports -w -local github.com/ignite/apps .; \
		fi \
	done
