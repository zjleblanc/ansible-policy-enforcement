# OPA test runner Makefile

# Default target
.DEFAULT_GOAL := test

# Variables
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m | sed 's/x86_64/amd64/')
OPA_VERSION := latest
OPA := $(shell pwd)/bin/opa

.PHONY: opa
opa: ## Download OPA locally if necessary.
ifeq (,$(wildcard $(OPA)))
ifeq (,$(shell which opa 2>/dev/null))
	@{ \
	set -e ;\
	mkdir -p $(dir $(OPA)) ;\
	curl -sSLo - https://github.com/open-policy-agent/opa/releases/download/$(OPA_VERSION)/opa_$(OS)_$(ARCH) > $(OPA) ;\
	chmod +x $(OPA) ;\
	}
else
OPA = $(shell which opa)
endif
endif

# Variables
TEST_DIR := test_aap_policy_examples
POLICY_DIR := aap_policy_examples

.PHONY: test
test: opa
	@echo "Running all OPA tests..."
	@$(OPA) test $(TEST_DIR) $(POLICY_DIR) --verbose

.PHONY: test-%
test-%: opa
	@echo "Running tests for $*..."
	@$(OPA) test $(TEST_DIR)/$*_test.rego $(POLICY_DIR)/$*.rego --verbose

.PHONY: test-coverage
test-coverage: opa
	@echo "Running tests with coverage report..."
	@$(OPA) test $(TEST_DIR) $(POLICY_DIR) --coverage --format=json

.PHONY: fmt
fmt: opa
	@echo "Formatting all rego files..."
	@$(OPA) fmt -w $(TEST_DIR) $(POLICY_DIR)

.PHONY: fmt-check
fmt-check: opa
	@echo "Checking rego file formatting..."
	@$(OPA) fmt -d $(TEST_DIR) $(POLICY_DIR)

.PHONY: check
check: opa
	@echo "Validating rego files..."
	@$(OPA) check $(TEST_DIR) $(POLICY_DIR)

.PHONY: clean
clean:
	@echo "Cleaning up..."
	@find . -type f -name "*.rego.bak" -delete

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  opa            - Download OPA locally if necessary"
	@echo "  test           - Run all OPA tests"
	@echo "  test-<policy>  - Run tests for a specific policy (e.g., test-allowed_false)"
	@echo "  test-coverage  - Run tests with coverage report"
	@echo "  fmt            - Format all rego files"
	@echo "  fmt-check      - Check if rego files are formatted correctly"
	@echo "  check          - Validate all rego files"
	@echo "  clean          - Clean up generated files"
	@echo "  help           - Show this help message" 
