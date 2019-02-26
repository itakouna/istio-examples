resource "aws_iam_role" "instance" {
    name                = "${var.name}-instance-role"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.instance.json}"
}

data "aws_iam_policy_document" "instance" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "instance" {
    role       = "${aws_iam_role.instance.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance" {
    name = "${var.name}-instance-profile"
    path = "/"
    role = "${aws_iam_role.instance.id}"
    provisioner "local-exec" {
      command = "sleep 10"
    }
}

resource "aws_iam_role" "service" {
    name                = "${var.name}-service-role"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.service.json}"
}

resource "aws_iam_role_policy_attachment" "service" {
    role       = "${aws_iam_role.service.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
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
