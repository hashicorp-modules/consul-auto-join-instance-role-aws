variable "create" {
  description = "Create Module, defaults to true."
  default     = true
}

variable "name" {
  description = "Name for resources, defaults to \"consul-auto-join-instance-role-aws\"."
  default     = "consul-auto-join-aws"
}
