variable "sp_name" {
  description = "Service Principal name"
  type = string
  nullable = false
}

variable "group_to_assign" {
  description = "Group name to which the service principal should be assigned"
  type = string
  nullable = false
}
