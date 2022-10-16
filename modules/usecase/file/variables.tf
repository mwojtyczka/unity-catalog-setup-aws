variable "usecase_user_group" {
  description = "Usecase user group name"
  type = string
  nullable = false
}

variable "usecase_admin_group" {
  description = "Usecase admin group name"
  type = string
  nullable = false
}

variable "owner" {
  description = "Principal name that should be the owner of storage credentials and external locations"
  type = string
  nullable = false
}

variable "data_bucket" {
  description = "Data bucket"
  type = string
  nullable = false
}

variable "data_role_arn" {
  description = "Data role arn"
  type = string
  nullable = false
}
