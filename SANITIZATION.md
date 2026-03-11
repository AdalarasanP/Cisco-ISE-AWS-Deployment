# Sanitization And First-Use Checklist

Use this checklist before running `terraform init` and `terraform plan` in a new environment.

## Required updates

1. Terraform Cloud org and workspace
- File: `.github/workflows/terraform-plan.yml`
- Replace: `REPLACE_ORG`, `REPLACE_WORKSPACE`
- File: `.github/workflows/terraform-apply.yml`
- Replace: `REPLACE_ORG`, `REPLACE_WORKSPACE`

2. Private module registry namespace
- File: `main.tf`
- Replace all occurrences of `app.terraform.io/REPLACE_ORG/...` with your registry namespace.

3. AMI IDs
- File: `main.tf`
- Replace:
  - `ami-REPLACE_ME_EAST`
  - `ami-REPLACE_ME_WEST`

4. Provider tags and metadata
- File: `provider.tf`
- Replace:
  - `REPLACE_DUD`
  - `replace-owner`
  - `replace-createdby`

5. IAM role naming
- File: `locals.tf`
- Replace:
  - `replace-terraform-role`
- Optional: replace placeholder account IDs if you use those locals for role assumptions:
  - `111111111111`, `222222222222`, `333333333333`, `444444444444`, `555555555555`

6. Environment values and secrets
- File: `terraform.tfvars.example`
- Replace all `replace-*` values (VPC names, key pair names, etc.) and copy to local `terraform.tfvars`.
- Replace `REPLACE_WITH_SECURE_SECRET` with a secure secret source.

## Security notes

1. `terraform.tfvars` is git-ignored in `.gitignore` and should not be committed.
2. Prefer secret injection from your CI/CD platform or Terraform Cloud variable sets instead of static files.
3. Validate final state with:
- `terraform fmt -recursive`
- `terraform init`
- `terraform validate`
- `terraform plan`
