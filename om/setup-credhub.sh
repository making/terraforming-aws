#!/bin/bash
set -eu

source $(dirname "$0")/common.sh

LOGIN_CREDENTIALS=$(om \
    --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
    --username "$OPS_MGR_USR" \
    --password "$OPS_MGR_PWD" \
    --skip-ssl-validation \
    curl \
    --silent \
    --path "/api/v0/deployed/director/credentials/uaa_login_client_credentials" \
    -x GET \
    | jq -r '.credential.value.password'
)

ADMIN_PASSWORD=$(om \
    --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
    --username "$OPS_MGR_USR" \
    --password "$OPS_MGR_PWD" \
    --skip-ssl-validation \
    curl \
    --silent \
    --path "/api/v0/deployed/director/credentials/uaa_admin_user_credentials" \
    -x GET \
    | jq -r '.credential.value.password'
)

cat <<EOF
uaac target \${BOSH_ENVIRONMENT}:8443 --ca-cert /var/tempest/workspaces/default/root_ca_certificate
uaac token owner get login admin -s ${LOGIN_CREDENTIALS} -p ${ADMIN_PASSWORD}
uaac client add credhub-cli \\
  --scope uaa.none \\
  --authorized_grant_types client_credentials \\
  --authorities "credhub.write,credhub.read" \\
  -s c1oudc0w

credhub login \\
        -s \${BOSH_ENVIRONMENT}:8844 \\
        --client-name=credhub-cli \\
        --client-secret=c1oudc0w \\
        --skip-tls-validation
EOF