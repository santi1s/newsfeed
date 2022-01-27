# WARNING: You don't need to edit this file

SHELL = $(PWD)/shim/shell


.EXPORT_ALL_VARIABLES:
# kind
CLUSTER_NAME = k8s.local
LOCAL_REGISTRY = local.registry
# Local Image Tag
LOCAL_TAG = dummy-V1.0.0

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.DEFAULT_GOAL := help


.PHONY: check
check: ## Checks all required tools are installed
	./scripts/check-installed-tools.sh

.PHONY: bootstrap-infra
bootstrap-infra:  ## Bootstrap cloud infra
	./scripts/bootstrap-cloud-infra.sh

.PHONY: bootstrap-kind
bootstrap-kind:  ## Bootstrap local kind cluster
	./scripts/bootstrap-kind-cluster.sh

.PHONY: build-artifacts
build-artifacts:  ## Builds project artifacts/docker images  
	./scripts/build-app-artifacts.sh 

.PHONY: push-artifacts
push-artifacts:  ## Push artifacts to Azure infra
	./scripts/push-app-artifacts.sh

.PHONY: deploy
deploy:  ## Deploys application manifest to kubernetes
	./scripts/deploy-app-manifests.sh

.PHONY: teardown-kind
teardown-kind:  ## Destroys local kind cluster and registry
	./scripts/delete-kind-cluster.sh

.PHONY: teardown
teardown-infra:  ## Destroys cloud infra (terraform remote state is preserved)
	./scripts/delete-cloud-infra.sh

.PHONY: full
full: check  bootstrap-kind build-artifacts push-artifacts deploy ## Runs the full CI/CD