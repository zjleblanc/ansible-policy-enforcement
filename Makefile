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
TOOLS_DIR := tools

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

# Containerized OPA Server
.PHONY: container/run-opa-server
container/run-opa-server: ## Run OPA server in container with file watching
	@echo "Starting OPA server with file watching..."
	@$(CONTAINER_RUNTIME) run \
		--rm \
		-p 8181:8181 \
		-v $(shell pwd)/$(POLICY_DIR):/policies \
		openpolicyagent/opa:$(OPA_VERSION) \
		run --server --addr=0.0.0.0:8181 --watch /policies

# OpenShift Deployment of OPA Server
.PHONY: openshift/deploy-opa-server
openshift/deploy-opa-server: ## Deploy OPA server to OpenShift
	@echo "Deploying OPA server to OpenShift..."
	@OPA_VERSION=$(OPA_VERSION) envsubst < openshift/opa-deployment.yaml | oc apply -f -

.PHONY: openshift/undeploy-opa-server
openshift/undeploy-opa-server: ## Remove OPA server from OpenShift
	@echo "Removing OPA server from OpenShift..."
	@OPA_VERSION=$(OPA_VERSION) envsubst < openshift/opa-deployment.yaml | oc delete -f -

.PHONY: openshift/load-policies
openshift/load-policies: ## Load all policies onto the deployed OPA server
	@echo "Loading policies onto OPA server..."
	@OPA_URL=$$(oc get route opa -o jsonpath='{.spec.host}') && \
	echo "OPA URL: $$OPA_URL" && \
	for policy in $(POLICY_DIR)/*.rego; do \
		policy_name=$$(basename "$$policy" .rego); \
		echo "Policy file: $$policy"; \
		echo "Policy name: $$policy_name"; \
		if curl -s -w "%{http_code}" -X PUT "http://$$OPA_URL/v1/policies/$$policy_name" \
			-H "Content-Type: text/plain" \
			--data-binary @$$policy | grep -q "200"; then \
			echo " ✓ Successfully loaded policy"; \
		else \
			echo " ✗ Failed to load policy"; \
		fi; \
	done

# Maintenance Targets
.PHONY: clean
clean: ## Clean up generated files
	@echo "Cleaning up..."
	@find . -type f -name "*.rego.bak" -delete

.PHONY: tools/sync_policy_docs
tools/sync_policy_docs: ## Sync policy documentation with actual policy files
	@echo "Syncing policy documentation with actual policy files..."
	@python3 $(TOOLS_DIR)/sync_policy_docs.py

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
