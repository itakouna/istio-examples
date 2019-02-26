resource "aws_autoscaling_group" "ecs" {
  name = "${var.name}-asg"

  launch_configuration = "${aws_launch_configuration.instance.name}"
  vpc_zone_identifier  = ["${module.vpc.vpc_subnets}"]
  max_size             = "${var.asg_max_size}"
  min_size             = "${var.asg_min_size}"
  desired_capacity     = "${var.asg_desired_size}"

  health_check_grace_period = 300
  health_check_type         = "ELB"

  lifecycle {
    create_before_destroy = true
  }
}
