terraform {
  required_version = ">= 0.9.3"
}

data "aws_iam_policy_document" "assume_role" {
  count = "${var.count}"

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
  count = "${var.count}"

  byte_length = 4
  prefix      = "${var.name}-${count.index + 1}-"
}

resource "aws_iam_role" "consul" {
  count = "${var.count}"

  name               = "${element(random_id.name.*.hex, count.index)}"
  assume_role_policy = "${element(data.aws_iam_policy_document.assume_role.*.json, count.index)}"
}

data "aws_iam_policy_document" "consul" {
  count = "${var.count}"

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
  count = "${var.count}"

  name   = "SelfAssembly"
  role   = "${element(aws_iam_role.consul.*.id, count.index)}"
  policy = "${element(data.aws_iam_policy_document.consul.*.json, count.index)}"
}

resource "aws_iam_instance_profile" "consul" {
  count = "${var.count}"

  name = "${element(random_id.name.*.hex, count.index)}"
  role = "${element(aws_iam_role.consul.*.name, count.index)}"
}
