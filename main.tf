terraform {
  required_version = ">= 0.9.3"
}

data "aws_iam_policy_document" "assume_role" {
  count = "${var.provision == "true" ? 1 : 0}"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "random_id" "name" {
  count = "${var.provision == "true" ? 1 : 0}"

  byte_length = 4
  prefix      = "${var.name}-"
}

resource "aws_iam_role" "consul" {
  count = "${var.provision == "true" ? 1 : 0}"

  name               = "${random_id.name.hex}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "consul" {
  count = "${var.provision == "true" ? 1 : 0}"

  statement {
    sid       = "AllowSelfAssembly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "ec2:DescribeVpcs",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
    ]
  }
}

resource "aws_iam_role_policy" "consul" {
  count = "${var.provision == "true" ? 1 : 0}"

  name   = "SelfAssembly"
  role   = "${aws_iam_role.consul.id}"
  policy = "${data.aws_iam_policy_document.consul.json}"
}

resource "aws_iam_instance_profile" "consul" {
  count = "${var.provision == "true" ? 1 : 0}"

  name = "${random_id.name.hex}"
  role = "${aws_iam_role.consul.name}"
}
