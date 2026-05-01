Terraform Infrastructure Workflow

Use GitHub Actions to validate, plan, and apply the Azure infrastructure in `infra/terraform/`.

Phase 1
Terraform Workflow
~2 hours

1.1
Add `.github/workflows/infra.yml`

The repo already has a lightweight IaC validation workflow in `.github/workflows/iac-validation.yml`. Keep that file for linting and non-backend validation. Add a separate workflow for real Terraform plan/apply against the Azure backend state.

1.2
Use the current Terraform inputs

The current Terraform root expects these runtime variables:

- `TF_VAR_admin_ssh_public_key`
- `TF_VAR_sql_admin_password`
- `TF_VAR_sonar_db_password`
- optional: `TF_VAR_admin_source_cidr`
- optional: `TF_VAR_appgw_hostname`
- optional: `TF_VAR_appgw_enable_https`
- optional: `TF_VAR_appgw_ssl_certificate_name`

The Azure provider should authenticate with:

- `ARM_CLIENT_ID`
- `ARM_TENANT_ID`
- `ARM_SUBSCRIPTION_ID`
- `ARM_USE_OIDC=true`
- `ARM_USE_AZUREAD=true`

Do not use the old `TF_VAR_sql_password` name. The current root variable is `sql_admin_password`.

1.3
Keep the Azure remote backend

The workflow should run against the remote `azurerm` backend already defined in `infra/terraform/backend.tf`, so use normal `terraform init` rather than `-backend=false`.

1.4
Recommended workflow behavior

Add a workflow with these requirements:

- trigger on `infra/terraform/**` and `.github/workflows/infra.yml`
- run `terraform fmt -check -recursive`
- run `terraform init -input=false`
- run `terraform validate`
- run `terraform plan -input=false -out=tfplan`
- upload the `tfplan` artifact on `main`
- run `terraform apply -input=false -auto-approve tfplan` only on pushes to `main`
- use `ubuntu-latest`
- use Terraform `1.14.9` to match the current local toolchain
- use `environment: production` on the apply job
- use a workflow concurrency group so infra applies do not overlap

Suggested structure:

```yaml
name: Terraform Infra

on:
  push:
    branches: [main]
    paths:
      - .github/workflows/infra.yml
      - infra/terraform/**
  pull_request:
    paths:
      - .github/workflows/infra.yml
      - infra/terraform/**
```

Use a `plan` job and a separate `apply` job. The apply job should download the saved `tfplan` artifact and apply that exact plan.

1.5
Secrets and variables required in GitHub

Add these repository secrets:

- `ADMIN_SSH_PUBLIC_KEY`
- `SQL_ADMIN_PASSWORD`
- `SONAR_DB_PASSWORD`

Add these repository variables:

- `ARM_CLIENT_ID`
- `ARM_TENANT_ID`
- `ARM_SUBSCRIPTION_ID`
- optional: `APPGW_HOSTNAME`
- optional: `LETSENCRYPT_EMAIL`

Optional repository variable:

- `ADMIN_SOURCE_CIDR`

1.6
Production note

The apply job uses `environment: production`. Configure required reviewers in the GitHub Environment settings if you want manual approval before apply.

The Terraform workflow can run on GitHub-hosted `ubuntu-latest` because it only talks to Azure control-plane APIs. App deployment remains different: Ansible must run on the self-hosted runner inside the ops network because the application VMs only have private IPs.

Use GitHub OIDC for the Terraform workflow instead of storing a long-lived Azure client secret. If `APPGW_HOSTNAME` is empty, Terraform now defaults the frontend hostname to `<public-ip-dashes>.sslip.io`.

The repository also includes `.github/workflows/appgw-certificate.yml`, which can issue or renew a browser-trusted Let's Encrypt certificate for the App Gateway hostname, import it into Key Vault under `appgw-ssl-cert`, and then re-apply Terraform with HTTPS enabled.

If `APPGW_HOSTNAME` is empty, the App Gateway hostname defaults to `<public-ip-dashes>.sslip.io`. The Let's Encrypt certificate must match the final hostname, either your explicit `APPGW_HOSTNAME` or the generated `sslip.io` hostname.

The real plan/apply workflow can skip forked pull requests because it needs Azure access and real Terraform inputs. The lightweight `.github/workflows/iac-validation.yml` workflow still covers formatting and validation for those PRs.
