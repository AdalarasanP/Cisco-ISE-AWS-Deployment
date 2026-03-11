# Terraform Cisco ISE Deployment (Sanitized Template)

This repository is a sanitized template for deploying Cisco ISE infrastructure across two AWS regions.

## What was sanitized

- Removed source repository git metadata.
- Replaced organization-specific account IDs, role names, tags, and workspace names.
- Replaced hardcoded AMI IDs, security group IDs, and prefix list IDs with placeholders.
- Removed real environment values from root tfvars and provided a safe example file.

## Before first use

1. Update values in `terraform.tfvars.example` for your environment.
2. Copy `terraform.tfvars.example` to a local `terraform.tfvars` (ignored by git).
3. Set Terraform Cloud values in:
   - `.github/workflows/terraform-plan.yml`
   - `.github/workflows/terraform-apply.yml`
4. Replace module source namespaces in `main.tf` (`REPLACE_ORG`).
5. Replace AMI placeholders in `main.tf`.

## Notes

- `terraform.tfvars` is intentionally ignored to avoid committing secrets.
- Validate with `terraform fmt`, `terraform init`, and `terraform plan` after customization.
