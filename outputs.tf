output "iaas" {
  value = "aws"
}

output "ops_manager_bucket" {
  value = "${module.ops_manager.bucket}"
}

output "ops_manager_public_ip" {
  value = "${module.ops_manager.public_ip}"
}

output "ops_manager_dns" {
  value = "${module.ops_manager.dns}"
}

output "optional_ops_manager_dns" {
  value = "${module.ops_manager.optional_dns}"
}

output "env_dns_zone_name_servers" {
  value = ["${compact(split(",", local.name_servers))}"]
}

output "pks_api_domain" {
  value = "api.${var.env_name}.${var.dns_suffix}"
}

output "ops_manager_iam_instance_profile_name" {
  value = "${aws_iam_instance_profile.ops_manager.name}"
}

output "ops_manager_iam_user_name" {
  value = "${aws_iam_user.ops_manager.name}"
}

output "ops_manager_iam_user_access_key" {
  value = "${aws_iam_access_key.ops_manager.id}"
}

output "ops_manager_iam_user_secret_key" {
  value = "${aws_iam_access_key.ops_manager.secret}"
}

output "ops_manager_security_group_id" {
  value = "${module.ops_manager.security_group_id}"
}

output "vms_security_group_id" {
  value = "${aws_security_group.vms_security_group.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}

output "public_subnet_availability_zones" {
  value = ["${aws_subnet.public_subnets.*.availability_zone}"]
}

output "public_subnet_cidrs" {
  value = ["${aws_subnet.public_subnets.*.cidr_block}"]
}

output "infrastructure_subnet_ids" {
  value = ["${aws_subnet.infrastructure_subnets.*.id}"]
}

output "infrastructure_subnets" {
  value = ["${aws_subnet.infrastructure_subnets.*.id}"]
}

output "infrastructure_subnet_availability_zones" {
  value = ["${aws_subnet.infrastructure_subnets.*.availability_zone}"]
}

output "infrastructure_subnet_cidrs" {
  value = ["${aws_subnet.infrastructure_subnets.*.cidr_block}"]
}

output "infrastructure_subnet_gateways" {
  value = ["${data.template_file.infrastructure_subnet_gateways.*.rendered}"]
}

output "pas_subnet_ids" {
  value = ["${aws_subnet.pas_subnets.*.id}"]
}

output "pas_subnets" {
  value = ["${aws_subnet.pas_subnets.*.id}"]
}

output "pas_subnet_availability_zones" {
  value = ["${aws_subnet.pas_subnets.*.availability_zone}"]
}

output "pas_subnet_cidrs" {
  value = ["${aws_subnet.pas_subnets.*.cidr_block}"]
}

output "pas_subnet_gateways" {
  value = ["${data.template_file.pas_subnet_gateways.*.rendered}"]
}

output "services_subnet_ids" {
  value = ["${aws_subnet.services_subnets.*.id}"]
}

output "services_subnets" {
  value = ["${aws_subnet.services_subnets.*.id}"]
}

output "services_subnet_availability_zones" {
  value = ["${aws_subnet.services_subnets.*.availability_zone}"]
}

output "services_subnet_cidrs" {
  value = ["${aws_subnet.services_subnets.*.cidr_block}"]
}

output "services_subnet_gateways" {
  value = ["${data.template_file.services_subnet_gateways.*.rendered}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "network_name" {
  value = "${aws_vpc.vpc.id}"
}

output "ops_manager_ssh_private_key" {
  sensitive = true
  value     = "${module.ops_manager.ssh_private_key}"
}

output "ops_manager_ssh_public_key_name" {
  value = "${module.ops_manager.ssh_public_key_name}"
}

output "ops_manager_ssh_public_key" {
  value = "${module.ops_manager.ssh_public_key}"
}

output "region" {
  value = "${var.region}"
}

output "azs" {
  value = "${var.availability_zones}"
}

output "pks_api_lb_name" {
  value = "${aws_elb.pks_api_elb.name}"
}

output "pks_api_elb_name" {
  value = "${aws_elb.pks_api_elb.name}"
}

output "pks_api_elb_dns_name" {
  value = "${aws_elb.pks_api_elb.dns_name}"
}

output "dns_zone_id" {
  value = "${local.zone_id}"
}

output "ops_manager_ip" {
  value = "${module.ops_manager.ops_manager_private_ip}"
}

output "ops_manager_private_ip" {
  value = "${module.ops_manager.ops_manager_private_ip}"
}

output "pks_worker_iam_user_name" {
  value = "${aws_iam_user.pks_worker.name}"
}

output "pks_worker_iam_user_access_key" {
  value = "${aws_iam_access_key.pks_worker.id}"
}

output "pks_worker_iam_user_secret_key" {
  value = "${aws_iam_access_key.pks_worker.secret}"
}

output "pks_master_iam_user_name" {
  value = "${aws_iam_user.pks_master.name}"
}

output "pks_master_iam_user_access_key" {
  value = "${aws_iam_access_key.pks_master.id}"
}

output "pks_master_iam_user_secret_key" {
  value = "${aws_iam_access_key.pks_master.secret}"
}

output "ops_manager_private_ip" {
  value = "${module.ops_manager.ops_manager_private_ip}"
}

/*****************************
 * Deprecated *
 *****************************/

output "management_subnet_ids" {
  value = ["${aws_subnet.infrastructure_subnets.*.id}"]
}

output "management_subnets" {
  value = ["${aws_subnet.infrastructure_subnets.*.id}"]
}

output "management_subnet_availability_zones" {
  value = ["${aws_subnet.infrastructure_subnets.*.availability_zone}"]
}

output "management_subnet_cidrs" {
  value = ["${aws_subnet.infrastructure_subnets.*.cidr_block}"]
}

output "management_subnet_gateways" {
  value = ["${data.template_file.infrastructure_subnet_gateways.*.rendered}"]
}
