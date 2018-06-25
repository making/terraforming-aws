resource "aws_elb" "pks_api_elb" {
  name                      = "${var.env_name}-pks-api-elb"
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 3
    interval            = 5
    target              = "TCP:9021"
    timeout             = 3
  }

  idle_timeout = 3600

  listener {
    instance_port     = 9021
    instance_protocol = "tcp"
    lb_port           = 9021
    lb_protocol       = "tcp"
  }
  
  listener {
    instance_port     = 8443
    instance_protocol = "tcp"
    lb_port           = 8443
    lb_protocol       = "tcp"
  }

  security_groups = ["${aws_security_group.pks_api_elb_security_group.id}"]
  subnets         = ["${aws_subnet.public_subnets.*.id}"]
}