#!/bin/bash
set -eu

source $(dirname "$0")/common.sh

om --target https://$OPSMAN_DOMAIN_OR_IP_ADDRESS \
  --skip-ssl-validation \
  --username "$OPS_MGR_USR" \
  --password "$OPS_MGR_PWD" \
  apply-changes \
  --ignore-warnings