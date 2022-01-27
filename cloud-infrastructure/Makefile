SHELL = $(PWD)/shim/shell
# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

.PHONY: state
state:  ## Create blob storage for terraform state
	cd ./scripts &&  m4 create-state-blob-azure.sh | dos2unix | bash

.PHONY: plan
plan:  ## Run terraform plan
	cd ./scripts && export CMD="plan" && m4 run-terraform.sh | dos2unix | bash

.PHONY: apply
apply: ## Run terraform apply
	cd ./scripts && export CMD="apply" &&  m4 run-terraform.sh | dos2unix | bash

.PHONY: destroy
destroy: ## Run terraform destroy
	cd ./scripts && export CMD="destroy" &&  m4 run-terraform.sh | dos2unix | bash

.PHONY: output
output: ## Run terraform output
	cd ./scripts && export CMD="output" &&  m4 run-terraform.sh | dos2unix | bash

.PHONY: kube-config
kube-config: ## Generate kube-config file
	cd ./scripts && m4 generate-kube-config.sh | dos2unix | bash