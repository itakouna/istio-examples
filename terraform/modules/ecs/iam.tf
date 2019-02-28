data "aws_iam_policy_document" "instance" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  name               = "${var.name}-${var.environment}-instance-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.instance.json}"
}

resource "aws_iam_role_policy_attachment" "instance" {
  role       = "${aws_iam_role.instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance" {
  name = "${var.name}-${var.environment}"
  role = "${aws_iam_role.instance.id}"
}

resource "aws_iam_role" "service" {
  name               = "${var.name}-${var.environment}-service-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.service.json}"
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = "${aws_iam_role.service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}