## Ansible Structure

This directory no longer uses static inventory files as the source of truth.

- `site.yml` bootstraps an in-memory inventory from `terraform output -json`
- Terraform remains the source of truth for host addresses, ACR naming, subnet CIDRs, and Key Vault naming
- Secrets are read at deploy time from Azure Key Vault by the target hosts through their managed identities

When you deploy a subset of hosts, the `--limit` pattern must still include `localhost` so the Terraform-output bootstrap play can run first.

- Example from outside the VNet: `ansible-playbook config/ansible/site.yml --limit "localhost,backend_vms"`
- Example from the ops runner or another host inside the VNet: `ANSIBLE_USE_BASTION=false ansible-playbook config/ansible/site.yml --limit "localhost,backend_vms"`

Expected control-node prerequisites:

- `terraform` installed
- Access to the Terraform state backend
- Azure authentication that Terraform can use against the remote backend
- SSH access to the ops VM public IP

Optional environment variables:

- `ANSIBLE_USER`
- `ANSIBLE_SSH_PRIVATE_KEY_FILE`
- `ANSIBLE_USE_BASTION`
- `ARM_USE_CLI`
- `ARM_USE_AZUREAD`
- `IMAGE_TAG`
- `BACKEND_CORS_ALLOWED_ORIGINS`
