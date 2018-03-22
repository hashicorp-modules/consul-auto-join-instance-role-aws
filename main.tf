terraform {
  required_version = ">= 0.9.3"
}

data "aws_iam_policy_document" "assume_role" {
  count = "${var.create ? 1 : 0}"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "consul" {
  count = "${var.create ? 1 : 0}"

  name_prefix        = "${var.name}-"
  assume_role_policy = "${element(data.aws_iam_policy_document.assume_role.*.json, 0)}"
}

data "aws_iam_policy_document" "consul" {
  count = "${var.create ? 1 : 0}"

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
  count = "${var.create ? 1 : 0}"

  name_prefix = "${var.name}-"
  role        = "${element(aws_iam_role.consul.*.id, 0)}"
  policy      = "${element(data.aws_iam_policy_document.consul.*.json, 0)}"
}

resource "aws_iam_instance_profile" "consul" {
  count = "${var.create ? 1 : 0}"

  name_prefix = "${var.name}-"
  role        = "${element(aws_iam_role.consul.*.name, 0)}"
}
