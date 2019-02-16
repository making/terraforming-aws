#!/bin/bash
set -eu

source $(dirname "$0")/common.sh




GUID=$(om \
    --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
    --username "$OPS_MGR_USR" \
    --password "$OPS_MGR_PWD" \
    --skip-ssl-validation \
    curl \
    --silent \
    --path "/api/v0/staged/products" \
    -x GET \
    | jq -r '.[] | select(.type == "pivotal-container-service") | .guid'
)
ADMIN_SECRET=$(om \
    --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
    --username "$OPS_MGR_USR" \
    --password "$OPS_MGR_PWD" \
    --skip-ssl-validation \
    curl \
    --silent \
    --path "/api/v0/deployed/products/${GUID}/credentials/.properties.pks_uaa_management_admin_client" \
    -x GET \
    | jq -r '.credential.value.secret'
)

PKS_DOMAIN=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pks_api_endpoint.value')

PKS_API_URL=https://${PKS_DOMAIN}:9021
UAA_URL=https://${PKS_DOMAIN}:8443

cat <<EOF

PKS_API_URL=${PKS_API_URL}
UAA_URL=${UAA_URL}
ADMIN_SECRET=${ADMIN_SECRET}
PKS_USER=demo@example.com
PKS_PASSWORD=demodemo1234
CLUSTER_NAME=pks-demo1

The following instruction shows how to create a cluster named "\${CLUSTER_NAME}"

### Grant Cluster Access to a User          
uaac target \${UAA_URL} --skip-ssl-validation
uaac token client get admin -s \${ADMIN_SECRET}
uaac user add \${PKS_USER} --emails \${PKS_USER} -p \${PKS_PASSWORD}
uaac member add pks.clusters.admin \${PKS_USER}
### Log in to PKS
pks login -k -a \${PKS_API_URL} -u \${PKS_USER} -p \${PKS_PASSWORD}

EOF
