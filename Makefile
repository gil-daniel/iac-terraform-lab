# Makefile for Terraform Azure Lab

TF=terraform
TFVARS=terraform.tfvars

init:
	$(TF) init

plan:
	$(TF) plan -var-file=$(TFVARS)

apply:
	$(TF) apply -var-file=$(TFVARS)

destroy:
	$(TF) destroy -var-file=$(TFVARS)

output:
	$(TF) output

refresh:
	$(TF) refresh

validate:
	$(TF) validate

format:
	$(TF) fmt -recursive

clean:
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup

help:
	@echo "Usage:"
	@echo "  make init      - Initialize Terraform"
	@echo "  make plan      - Show execution plan"
	@echo "  make apply     - Apply the configuration"
	@echo "  make destroy   - Destroy all resources"
	@echo "  make output    - Show output values"
	@echo "  make validate  - Validate Terraform files"
	@echo "  make format    - Format Terraform code"
	@echo "  make clean     - Remove local state and cache"

