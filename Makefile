# Makefile for Terraform Azure Lab
# Simplifies common Terraform commands with shortcuts

TF=terraform
TFVARS=terraform.tfvars

# Initializes the Terraform working directory
init:
    $(TF) init

# Generates and displays the execution plan using the tfvars file
plan:
    $(TF) plan -var-file=$(TFVARS)

# Applies the Terraform configuration using the tfvars file
apply:
    $(TF) apply -var-file=$(TFVARS)

# Destroys all resources defined in the configuration
destroy:
    $(TF) destroy -var-file=$(TFVARS)

# Displays the output values defined in outputs.tf
output:
    $(TF) output

# Refreshes the Terraform state to match real infrastructure
refresh:
    $(TF) refresh

# Validates the syntax and structure of Terraform files
validate:
    $(TF) validate

# Formats all Terraform files recursively for consistency
format:
    $(TF) fmt -recursive

# Cleans up local Terraform state and cache files
clean:
    rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup

# Displays usage instructions for available Makefile commands
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
