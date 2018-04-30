output "iam_role_id" {
  value = "${module.consul_auto_join_instance_role.iam_role_id}"
}

output "instance_profile_id" {
  value = "${module.consul_auto_join_instance_role.instance_profile_id}"
}
