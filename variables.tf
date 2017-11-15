variable "provision" {
  default     = "true"
  description = "Override to prevent provisioning resources in this module, defaults to \"true\"."
}

variable "name" {
  default     = "consul-auto-join-instance-role-aws"
  description = "Name for resources, defaults to \"consul-auto-join-instance-role-aws\"."
}
