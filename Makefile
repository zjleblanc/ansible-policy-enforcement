# Default target
.DEFAULT_GOAL := help

# Build and Environment Variables
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m | sed 's/x86_64/amd64/')
OPA_VERSION := latest
CONTAINER_RUNTIME ?= podman

# Directory Variables
TEST_DIR := test_aap_policy_examples
POLICY_DIR := aap_policy_examples

# OPA Binary Management
OPA := $(shell pwd)/bin/opa

.PHONY: opa
opa: ## Download OPA locally if necessary
ifeq (,$(wildcard $(OPA)))
ifeq (,$(shell which opa 2>/dev/null))
	@{ \
	set -e ;\
	mkdir -p $(dir $(OPA)) ;\
	curl -L -o $(OPA) https://openpolicyagent.org/downloads/$(OPA_VERSION)/opa_$(OS)_$(ARCH)_static ;\
	chmod +x $(OPA) ;\
	}
else
	$(eval OPA := $(shell which opa))
endif
endif

# Testing Targets
.PHONY: test
test: opa ## Run all OPA tests
	@echo "Running all OPA tests..."
	@$(OPA) test $(TEST_DIR) $(POLICY_DIR) --verbose

.PHONY: test-%
test-%: opa ## Run tests for a specific policy (e.g., make test-allowed_false)
	@echo "Running tests for $*..."
	@$(OPA) test $(TEST_DIR)/$*_test.rego $(POLICY_DIR)/$*.rego --verbose

.PHONY: test-coverage
test-coverage: opa ## Run tests with coverage report
	@echo "Running tests with coverage report..."
	@$(OPA) test $(TEST_DIR) $(POLICY_DIR) --coverage --format=json

# Code Quality Targets
.PHONY: fmt
fmt: opa ## Format all rego files
	@echo "Formatting all rego files..."
	@$(OPA) fmt -w $(TEST_DIR) $(POLICY_DIR)

.PHONY: fmt-check
fmt-check: opa ## Check if rego files are formatted correctly
	@echo "Checking rego file formatting..."
	@$(OPA) fmt -d $(TEST_DIR) $(POLICY_DIR)

.PHONY: check
check: opa ## Validate all rego files
	@echo "Validating rego files..."
	@$(OPA) check $(TEST_DIR) $(POLICY_DIR)

# Development Server
.PHONY: opa-server
opa-server: ## Run OPA server in container with file watching
	@echo "Starting OPA server with file watching..."
	@$(CONTAINER_RUNTIME) run \
		--rm \
		-p 8181:8181 \
		-v $(shell pwd)/$(POLICY_DIR):/policies \
		openpolicyagent/opa:$(OPA_VERSION) \
		run --server --addr=0.0.0.0:8181 --watch /policies

# Maintenance Targets
.PHONY: clean
clean: ## Clean up generated files
	@echo "Cleaning up..."
	@find . -type f -name "*.rego.bak" -delete

# Help and Documentation
.PHONY: help
help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk '/^[a-zA-Z\-_0-9%]+:/ { \
		helpMessage = match($$0, /^([^:]+):[^#]*## (.+)/); \
		if (helpMessage) { \
			helpCommand = substr($$0, 1, index($$0, ":")-1); \
			helpMessage = substr($$0, index($$0, "##") + 3); \
			printf "  %-20s %s\n", helpCommand, helpMessage; \
		} \
	}' $(MAKEFILE_LIST) | sort
