output "iam_role_id" {
  value = "${aws_iam_role.consul.*.id}"
}

output "instance_profile_id" {
  value = "${aws_iam_instance_profile.consul.*.id}"
}
