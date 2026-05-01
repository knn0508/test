#!/usr/bin/env bash

set -euo pipefail

for required_var in TF_STATE_STORAGE_ACCOUNT TF_STATE_CONTAINER TF_STATE_BLOB_KEY; do
  if [ -z "${!required_var:-}" ]; then
    echo "Missing required environment variable: ${required_var}" >&2
    exit 1
  fi
done

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI is not available; skipping remote state lock preflight."
  exit 0
fi

blob_exists="$(
  az storage blob exists \
    --account-name "${TF_STATE_STORAGE_ACCOUNT}" \
    --container-name "${TF_STATE_CONTAINER}" \
    --name "${TF_STATE_BLOB_KEY}" \
    --auth-mode login \
    --query "exists" \
    --output tsv
)"

if [ "${blob_exists}" != "true" ]; then
  echo "Terraform state blob does not exist yet; continuing."
  exit 0
fi

blob_json="$(
  az storage blob show \
    --account-name "${TF_STATE_STORAGE_ACCOUNT}" \
    --container-name "${TF_STATE_CONTAINER}" \
    --name "${TF_STATE_BLOB_KEY}" \
    --auth-mode login \
    --output json
)"

readarray -t lease_info < <(
  python3 - <<'PY' <<<"${blob_json}"
import json
import sys

data = json.load(sys.stdin)
props = data.get("properties") or {}
lease = props.get("lease") or {}

def pick(*values):
    for value in values:
        if value:
            return str(value)
    return ""

print(pick(lease.get("status"), props.get("leaseStatus")).lower())
print(pick(lease.get("state"), props.get("leaseState")).lower())
print(pick(lease.get("duration"), props.get("leaseDuration")).lower())
PY
)

lease_status="${lease_info[0]:-}"
lease_state="${lease_info[1]:-}"
lease_duration="${lease_info[2]:-}"

echo "Remote state lease status: ${lease_status:-unknown}"
echo "Remote state lease state: ${lease_state:-unknown}"
if [ -n "${lease_duration}" ]; then
  echo "Remote state lease duration: ${lease_duration}"
fi

if [ "${lease_status}" = "locked" ] || [ "${lease_state}" = "leased" ]; then
  cat >&2 <<EOF
Terraform remote state is currently locked.
Storage account: ${TF_STATE_STORAGE_ACCOUNT}
Container: ${TF_STATE_CONTAINER}
Blob: ${TF_STATE_BLOB_KEY}

If this lock is stale, release it manually before rerunning, for example:
  terraform -chdir=infra/terraform force-unlock -force <LOCK_ID>

This workflow will not continue while the remote state blob is leased.
EOF
  exit 1
fi

echo "Terraform remote state is not currently locked."
