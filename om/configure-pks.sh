set -e

source $(dirname "$0")/common.sh

PRODUCT_NAME=pivotal-container-service

PKS_API_IP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pks_api_elb_dns_name.value')
PKS_DOMAIN=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pks_api_endpoint.value')
PKS_MAIN_NETWORK_NAME=pks-main
PKS_SERVICES_NETWORK_NAME=pks-services
SINGLETON_AVAILABILITY_ZONE=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.azs.value[0]')
AVAILABILITY_ZONES=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.azs.value | map({name: .})' | tr -d '\n' | tr -d '"')
AVAILABILITY_ZONE_NAMES=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.azs.value' | tr -d '\n' | tr -d '"')

if [ "${CERT_PEM}" == "" ];then
  WILDCARD_DOMAIN=`echo ${OPSMAN_DOMAIN_OR_IP_ADDRESS} | sed 's/pcf/*/g'`
  CERTIFICATES=`om --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
     --username "$OPS_MGR_USR" \
     --password "$OPS_MGR_PWD" \
     --skip-ssl-validation\
     generate-certificate -d ${WILDCARD_DOMAIN}`
  CERT_PEM=`echo $CERTIFICATES | jq -r '.certificate'`
  KEY_PEM=`echo $CERTIFICATES | jq -r '.key'`
fi
CERT_PEM=`cat <<EOF | sed 's/^/        /'
${CERT_PEM}
EOF
`
KEY_PEM=`cat <<EOF | sed 's/^/        /'
${KEY_PEM}
EOF
`
INSTANCE_PROFILE_MASTER=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pks_master_iam_instance_profile_name.value')
INSTANCE_PROFILE_WORKER=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pks_worker_iam_instance_profile_name.value')
API_HOSTNAME=${PKS_DOMAIN}
UAA_URL=${PKS_DOMAIN}
LB_NAME=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[4].resources["aws_lb.pks_api"].primary.attributes.name')

cat <<EOF > /tmp/pks.yml
---
product-properties:
  .pivotal-container-service.pks_tls:
    value:
      cert_pem: |
$CERT_PEM
      private_key_pem: |
$KEY_PEM
  .properties.pks_api_hostname:
    value: $API_HOSTNAME
  .properties.plan1_selector:
    value: Plan Active
  .properties.plan1_selector.active.master_az_placement:
    value: $AVAILABILITY_ZONE_NAMES
  .properties.plan1_selector.active.master_vm_type:
    value: t2.small
  .properties.plan1_selector.active.worker_az_placement:
    value: $AVAILABILITY_ZONE_NAMES
  .properties.plan1_selector.active.worker_vm_type:
    value: t2.medium
  .properties.plan1_selector.active.worker_persistent_disk_type:
    value: "51200"
  .properties.plan1_selector.active.worker_instances:
    value: 1
  .properties.plan1_selector.active.errand_vm_type:
    value: t2.small
  .properties.plan1_selector.active.addons_spec:
    value: |
      apiVersion: storage.k8s.io/v1
      kind: StorageClass
      metadata:
        name: standard
        annotations:
          storageclass.beta.kubernetes.io/is-default-class: "true"
        labels:
          kubernetes.io/cluster-service: "true"
          addonmanager.kubernetes.io/mode: EnsureExists
      provisioner: kubernetes.io/aws-ebs
      allowVolumeExpansion: true
      parameters:
        type: gp2
      ---
  .properties.plan1_selector.active.allow_privileged_containers:
    value: 1
  .properties.plan2_selector:
    value: Plan Active
  .properties.plan2_selector.active.master_az_placement:
    value: $AVAILABILITY_ZONE_NAMES
  .properties.plan2_selector.active.master_vm_type:
    value: t2.small
  .properties.plan2_selector.active.worker_az_placement:
    value: $AVAILABILITY_ZONE_NAMES
  .properties.plan2_selector.active.worker_vm_type:
    value: m4.large
  .properties.plan2_selector.active.worker_persistent_disk_type:
    value: "102400"
  .properties.plan2_selector.active.worker_instances:
    value: 3
  .properties.plan2_selector.active.errand_vm_type:
    value: t2.small
  .properties.plan2_selector.active.addons_spec:
    value: |
      apiVersion: storage.k8s.io/v1
      kind: StorageClass
      metadata:
        name: standard
        annotations:
          storageclass.beta.kubernetes.io/is-default-class: "true"
        labels:
          kubernetes.io/cluster-service: "true"
          addonmanager.kubernetes.io/mode: EnsureExists
      provisioner: kubernetes.io/aws-ebs
      allowVolumeExpansion: true
      parameters:
        type: gp2
      ---
  .properties.plan2_selector.active.allow_privileged_containers:
    value: 1
  .properties.plan3_selector:
    value: Plan Inactive
  .properties.cloud_provider:
    value: AWS
  .properties.cloud_provider.aws.iam_instance_profile_master:
    value: $INSTANCE_PROFILE_MASTER
  .properties.cloud_provider.aws.iam_instance_profile_worker:
    value: $INSTANCE_PROFILE_WORKER
  .properties.telemetry_selector:
    value: enabled
  .properties.uaa_oidc:
    value: true
network-properties:
  network:
    name: $PKS_MAIN_NETWORK_NAME
  service_network:
    name: $PKS_SERVICES_NETWORK_NAME
  other_availability_zones: $AVAILABILITY_ZONES
  singleton_availability_zone:
    name: $SINGLETON_AVAILABILITY_ZONE
resource-config:
  pivotal-container-service:
    instance_type:
      id: c4.large
    elb_names:
    - $LB_NAME
EOF
cat /tmp/pks.yml

om --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
   --username "$OPS_MGR_USR" \
   --password "$OPS_MGR_PWD" \
   --skip-ssl-validation \
   configure-product \
   --product-name "${PRODUCT_NAME}" \
   --config /tmp/pks.yml

echo "PKS API: https://${PKS_DOMAIN}:9021"
echo "UAA: https://${PKS_DOMAIN}:8443"
