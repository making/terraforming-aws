#!/bin/bash

export OPS_MGR_USR=admin
export OPS_MGR_PWD=changeme
export OM_DECRYPTION_PWD=changeme



export TF_DIR=$(dirname "$0")/..
export OPSMAN_DOMAIN_OR_IP_ADDRESS=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_public_ip.value')