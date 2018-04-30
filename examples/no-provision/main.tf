module "consul_auto_join_instance_role" {
  # source = "github.com/hashicorp-modules/consul-auto-join-instance-role-aws"
  source = "../../../consul-auto-join-instance-role-aws"

  create = false
}
