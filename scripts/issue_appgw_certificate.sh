#!/usr/bin/env bash

set -euo pipefail

TERRAFORM_DIR="${TERRAFORM_DIR:-infra/terraform}"
LETSENCRYPT_EMAIL="${LETSENCRYPT_EMAIL:?LETSENCRYPT_EMAIL must be set}"
APPGW_CERTIFICATE_NAME="${APPGW_CERTIFICATE_NAME:-appgw-ssl-cert}"
ACME_WEBROOT="${ACME_WEBROOT:-/tmp/acme-webroot}"
ACME_HTTP_PORT="${ACME_HTTP_PORT:-8089}"
WORK_DIR="${WORK_DIR:-/tmp/appgw-certificate}"

for required_command in az curl openssl python3 terraform; do
  if ! command -v "${required_command}" >/dev/null 2>&1; then
    echo "Missing required command: ${required_command}" >&2
    exit 1
  fi
done

mkdir -p "${ACME_WEBROOT}/.well-known/acme-challenge" "${WORK_DIR}"

cleanup() {
  if [ -n "${ACME_SERVER_PID:-}" ]; then
    kill "${ACME_SERVER_PID}" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

terraform -chdir="${TERRAFORM_DIR}" init -input=false -reconfigure

APPGW_HOSTNAME="$(terraform -chdir="${TERRAFORM_DIR}" output -raw appgw_hostname)"
KEY_VAULT_NAME="$(terraform -chdir="${TERRAFORM_DIR}" output -raw key_vault_name)"

if [ -z "${APPGW_HOSTNAME}" ]; then
  echo "Terraform did not return an App Gateway hostname." >&2
  exit 1
fi

python3 -m http.server "${ACME_HTTP_PORT}" --directory "${ACME_WEBROOT}" >"${WORK_DIR}/acme-http.log" 2>&1 &
ACME_SERVER_PID=$!

if [ ! -x "${HOME}/.acme.sh/acme.sh" ]; then
  curl -fsSL https://get.acme.sh -o "${WORK_DIR}/install-acme.sh"
  sh "${WORK_DIR}/install-acme.sh" email="${LETSENCRYPT_EMAIL}"
fi

ACME_SH="${HOME}/.acme.sh/acme.sh"
"${ACME_SH}" --set-default-ca --server letsencrypt
"${ACME_SH}" --register-account -m "${LETSENCRYPT_EMAIL}" --server letsencrypt || true
"${ACME_SH}" --issue -d "${APPGW_HOSTNAME}" -w "${ACME_WEBROOT}" --server letsencrypt --keylength 2048

KEY_FILE="${WORK_DIR}/${APPGW_HOSTNAME}.key"
FULLCHAIN_FILE="${WORK_DIR}/${APPGW_HOSTNAME}.fullchain.pem"
PFX_FILE="${WORK_DIR}/${APPGW_HOSTNAME}.pfx"
PFX_PASSWORD="$(openssl rand -hex 24)"

"${ACME_SH}" --install-cert -d "${APPGW_HOSTNAME}" --key-file "${KEY_FILE}" --fullchain-file "${FULLCHAIN_FILE}"
openssl pkcs12 -export -out "${PFX_FILE}" -inkey "${KEY_FILE}" -in "${FULLCHAIN_FILE}" -password "pass:${PFX_PASSWORD}"

az keyvault certificate import \
  --vault-name "${KEY_VAULT_NAME}" \
  --name "${APPGW_CERTIFICATE_NAME}" \
  --file "${PFX_FILE}" \
  --password "${PFX_PASSWORD}" \
  --only-show-errors >/dev/null

TF_VAR_appgw_enable_https=true TF_VAR_appgw_ssl_certificate_name="${APPGW_CERTIFICATE_NAME}" terraform -chdir="${TERRAFORM_DIR}" apply -input=false -auto-approve
