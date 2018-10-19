#!/bin/bash

set -e

source $(dirname "$0")/common.sh

# IaaS
ACCESS_KEY_ID=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_iam_user_access_key.value')
SECRET_ACCESS_KEY=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_iam_user_secret_key.value')
SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.vms_security_group_id.value')
KEY_PAIR_NAME=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_ssh_public_key_name.value')
SSH_PRIVATE_KEY=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_ssh_private_key.value' | sed 's/^/    /')
REGION=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.region.value')
## Director
OPS_MANAGER_BUCKET=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_bucket.value')
## Networks
AVAILABILITY_ZONES=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.azs.value | map({name: .})' | tr -d '\n' | tr -d '"')
INFRASTRUCTURE_NETWORK_NAME=pks-infrastructure
INFRASTRUCTURE_IAAS_IDENTIFIER_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_ids.value[0]')
INFRASTRUCTURE_NETWORK_CIDR_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_cidrs.value[0]')
INFRASTRUCTURE_RESERVED_IP_RANGES_0=$(echo $INFRASTRUCTURE_NETWORK_CIDR_0 | sed 's|0/28$|0|g')-$(echo $INFRASTRUCTURE_NETWORK_CIDR_0 | sed 's|0/28$|4|g')
INFRASTRUCTURE_DNS_0=10.0.0.2
INFRASTRUCTURE_GATEWAY_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_gateways.value[0]')
INFRASTRUCTURE_AVAILABILITY_ZONES_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_availability_zones.value[0]')
INFRASTRUCTURE_IAAS_IDENTIFIER_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_ids.value[1]')
INFRASTRUCTURE_NETWORK_CIDR_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_cidrs.value[1]')
INFRASTRUCTURE_RESERVED_IP_RANGES_1=$(echo $INFRASTRUCTURE_NETWORK_CIDR_1 | sed 's|16/28$|16|g')-$(echo $INFRASTRUCTURE_NETWORK_CIDR_1 | sed 's|16/28$|20|g')
INFRASTRUCTURE_DNS_1=10.0.0.2
INFRASTRUCTURE_GATEWAY_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_gateways.value[1]')
INFRASTRUCTURE_AVAILABILITY_ZONES_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_availability_zones.value[1]')
INFRASTRUCTURE_IAAS_IDENTIFIER_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_ids.value[2]')
INFRASTRUCTURE_NETWORK_CIDR_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_cidrs.value[2]')
INFRASTRUCTURE_RESERVED_IP_RANGES_2=$(echo $INFRASTRUCTURE_NETWORK_CIDR_2 | sed 's|32/28$|32|g')-$(echo $INFRASTRUCTURE_NETWORK_CIDR_2 | sed 's|32/28$|36|g')
INFRASTRUCTURE_DNS_2=10.0.0.2
INFRASTRUCTURE_GATEWAY_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_gateways.value[2]')
INFRASTRUCTURE_AVAILABILITY_ZONES_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_availability_zones.value[2]')
DEPLOYMENT_NETWORK_NAME=pks-main
DEPLOYMENT_IAAS_IDENTIFIER_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_ids.value[0]')
DEPLOYMENT_NETWORK_CIDR_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_cidrs.value[0]')
DEPLOYMENT_RESERVED_IP_RANGES_0=$(echo $DEPLOYMENT_NETWORK_CIDR_0 | sed 's|0/24$|0|g')-$(echo $DEPLOYMENT_NETWORK_CIDR_0 | sed 's|0/24$|4|g')
DEPLOYMENT_DNS_0=10.0.0.2
DEPLOYMENT_GATEWAY_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_gateways.value[0]')
DEPLOYMENT_AVAILABILITY_ZONES_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_availability_zones.value[0]')
DEPLOYMENT_IAAS_IDENTIFIER_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_ids.value[1]')
DEPLOYMENT_NETWORK_CIDR_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_cidrs.value[1]')
DEPLOYMENT_RESERVED_IP_RANGES_1=$(echo $DEPLOYMENT_NETWORK_CIDR_1 | sed 's|0/24$|0|g')-$(echo $DEPLOYMENT_NETWORK_CIDR_1 | sed 's|0/24$|4|g')
DEPLOYMENT_DNS_1=10.0.0.2
DEPLOYMENT_GATEWAY_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_gateways.value[1]')
DEPLOYMENT_AVAILABILITY_ZONES_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_availability_zones.value[1]')
DEPLOYMENT_IAAS_IDENTIFIER_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_ids.value[2]')
DEPLOYMENT_NETWORK_CIDR_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_cidrs.value[2]')
DEPLOYMENT_RESERVED_IP_RANGES_2=$(echo $DEPLOYMENT_NETWORK_CIDR_2 | sed 's|0/24$|0|g')-$(echo $DEPLOYMENT_NETWORK_CIDR_2 | sed 's|0/24$|4|g')
DEPLOYMENT_DNS_2=10.0.0.2
DEPLOYMENT_GATEWAY_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_gateways.value[2]')
DEPLOYMENT_AVAILABILITY_ZONES_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_availability_zones.value[2]')
SERVICES_NETWORK_NAME=pks-services
SERVICES_IAAS_IDENTIFIER_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_ids.value[0]')
SERVICES_NETWORK_CIDR_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_cidrs.value[0]')
SERVICES_RESERVED_IP_RANGES_0=$(echo $SERVICES_NETWORK_CIDR_0 | sed 's|0/24$|0|g')-$(echo $SERVICES_NETWORK_CIDR_0 | sed 's|0/24$|3|g')
SERVICES_DNS_0=10.0.0.2
SERVICES_GATEWAY_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_gateways.value[0]')
SERVICES_AVAILABILITY_ZONES_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_availability_zones.value[0]')
SERVICES_IAAS_IDENTIFIER_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_ids.value[1]')
SERVICES_NETWORK_CIDR_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_cidrs.value[1]')
SERVICES_RESERVED_IP_RANGES_1=$(echo $SERVICES_NETWORK_CIDR_1 | sed 's|0/24$|0|g')-$(echo $SERVICES_NETWORK_CIDR_1 | sed 's|0/24$|3|g')
SERVICES_DNS_1=10.0.0.2
SERVICES_GATEWAY_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_gateways.value[1]')
SERVICES_AVAILABILITY_ZONES_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_availability_zones.value[1]')
SERVICES_IAAS_IDENTIFIER_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_ids.value[2]')
SERVICES_NETWORK_CIDR_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_cidrs.value[2]')
SERVICES_RESERVED_IP_RANGES_2=$(echo $SERVICES_NETWORK_CIDR_2 | sed 's|0/24$|0|g')-$(echo $SERVICES_NETWORK_CIDR_2 | sed 's|0/24$|3|g')
SERVICES_DNS_2=10.0.0.2
SERVICES_GATEWAY_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_gateways.value[2]')
SERVICES_AVAILABILITY_ZONES_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_availability_zones.value[2]')
SINGLETON_AVAILABILITY_NETWORK=$INFRASTRUCTURE_NETWORK_NAME
SINGLETON_AVAILABILITY_ZONE=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.azs.value[0]')
OPS_MGR_TRUSTED_CERTS=$(echo $OPS_MGR_TRUSTED_CERTS | sed 's/^/        /')

cat <<EOF > /tmp/director.yml
---
iaas-configuration:
  access_key_id: $ACCESS_KEY_ID
  secret_access_key: $SECRET_ACCESS_KEY
  security_group: $SECURITY_GROUP
  key_pair_name: $KEY_PAIR_NAME
  ssh_private_key: |
$SSH_PRIVATE_KEY
  region: $REGION
director-configuration:
  ntp_servers_string: 0.amazon.pool.ntp.org,1.amazon.pool.ntp.org,2.amazon.pool.ntp.org,3.amazon.pool.ntp.org
  resurrector_enabled: true
  post_deploy_enabled: true
  database_type: internal
  blobstore_type: s3
  s3_blobstore_options:
    endpoint: https://s3-${REGION}.amazonaws.com
    bucket_name: $OPS_MANAGER_BUCKET
    access_key: $ACCESS_KEY_ID
    secret_key: $SECRET_ACCESS_KEY
    signature_version: "4"
    region: $REGION
az-configuration: $AVAILABILITY_ZONES
networks-configuration:
  icmp_checks_enabled: false
  networks:
  - name: $INFRASTRUCTURE_NETWORK_NAME
    service_network: false
    subnets:
    - iaas_identifier: $INFRASTRUCTURE_IAAS_IDENTIFIER_0
      cidr: $INFRASTRUCTURE_NETWORK_CIDR_0
      reserved_ip_ranges: $INFRASTRUCTURE_RESERVED_IP_RANGES_0
      dns: $INFRASTRUCTURE_DNS_0
      gateway: $INFRASTRUCTURE_GATEWAY_0
      availability_zone_names: 
      - $INFRASTRUCTURE_AVAILABILITY_ZONES_0
    - iaas_identifier: $INFRASTRUCTURE_IAAS_IDENTIFIER_1
      cidr: $INFRASTRUCTURE_NETWORK_CIDR_1
      reserved_ip_ranges: $INFRASTRUCTURE_RESERVED_IP_RANGES_1
      dns: $INFRASTRUCTURE_DNS_1
      gateway: $INFRASTRUCTURE_GATEWAY_1
      availability_zone_names: 
      - $INFRASTRUCTURE_AVAILABILITY_ZONES_1
    - iaas_identifier: $INFRASTRUCTURE_IAAS_IDENTIFIER_2
      cidr: $INFRASTRUCTURE_NETWORK_CIDR_2
      reserved_ip_ranges: $INFRASTRUCTURE_RESERVED_IP_RANGES_2
      dns: $INFRASTRUCTURE_DNS_2
      gateway: $INFRASTRUCTURE_GATEWAY_2
      availability_zone_names: 
      - $INFRASTRUCTURE_AVAILABILITY_ZONES_2
  - name: $DEPLOYMENT_NETWORK_NAME
    service_network: false
    subnets:
    - iaas_identifier: $DEPLOYMENT_IAAS_IDENTIFIER_0
      cidr: $DEPLOYMENT_NETWORK_CIDR_0
      reserved_ip_ranges: $DEPLOYMENT_RESERVED_IP_RANGES_0
      dns: $DEPLOYMENT_DNS_0
      gateway: $DEPLOYMENT_GATEWAY_0
      availability_zone_names:
      - $DEPLOYMENT_AVAILABILITY_ZONES_0
    - iaas_identifier: $DEPLOYMENT_IAAS_IDENTIFIER_1
      cidr: $DEPLOYMENT_NETWORK_CIDR_1
      reserved_ip_ranges: $DEPLOYMENT_RESERVED_IP_RANGES_1
      dns: $DEPLOYMENT_DNS_1
      gateway: $DEPLOYMENT_GATEWAY_1
      availability_zone_names:
      - $DEPLOYMENT_AVAILABILITY_ZONES_1
    - iaas_identifier: $DEPLOYMENT_IAAS_IDENTIFIER_2
      cidr: $DEPLOYMENT_NETWORK_CIDR_2
      reserved_ip_ranges: $DEPLOYMENT_RESERVED_IP_RANGES_2
      dns: $DEPLOYMENT_DNS_2
      gateway: $DEPLOYMENT_GATEWAY_2
      availability_zone_names:
      - $DEPLOYMENT_AVAILABILITY_ZONES_2
  - name: $SERVICES_NETWORK_NAME
    service_network: true
    subnets:
    - iaas_identifier: $SERVICES_IAAS_IDENTIFIER_0
      cidr: $SERVICES_NETWORK_CIDR_0
      reserved_ip_ranges: $SERVICES_RESERVED_IP_RANGES_0
      dns: $SERVICES_DNS_0
      gateway: $SERVICES_GATEWAY_0
      availability_zone_names:
      - $SERVICES_AVAILABILITY_ZONES_0
    - iaas_identifier: $SERVICES_IAAS_IDENTIFIER_1
      cidr: $SERVICES_NETWORK_CIDR_1
      reserved_ip_ranges: $SERVICES_RESERVED_IP_RANGES_1
      dns: $SERVICES_DNS_1
      gateway: $SERVICES_GATEWAY_1
      availability_zone_names:
      - $SERVICES_AVAILABILITY_ZONES_1
    - iaas_identifier: $SERVICES_IAAS_IDENTIFIER_2
      cidr: $SERVICES_NETWORK_CIDR_2
      reserved_ip_ranges: $SERVICES_RESERVED_IP_RANGES_2
      dns: $SERVICES_DNS_2
      gateway: $SERVICES_GATEWAY_2
      availability_zone_names:
      - $SERVICES_AVAILABILITY_ZONES_2
network-assignment:
  network:
    name: $SINGLETON_AVAILABILITY_NETWORK
  singleton_availability_zone:
    name: $SINGLETON_AVAILABILITY_ZONE
security-configuration:
  trusted_certificates: |
$OPS_MGR_TRUSTED_CERTS
  vm_password_type: generate
resource-configuration:
  director:
    instance_type:
      id: automatic
  compilation:
    instance_type:
      id: automatic
EOF

cat /tmp/director.yml

om --target https://$OPSMAN_DOMAIN_OR_IP_ADDRESS \
  --skip-ssl-validation \
  --username "$OPS_MGR_USR" \
  --password "$OPS_MGR_PWD" \
  configure-director \
  --config /tmp/director.yml

