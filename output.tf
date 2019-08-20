output "iam_role_id" {
  value = element(concat(aws_iam_role.consul.*.id, [""]), 0) # TODO: Workaround for issue #11210
}

output "instance_profile_id" {
  value = element(concat(aws_iam_instance_profile.consul.*.id, [""]), 0) # TODO: Workaround for issue #11210
}

