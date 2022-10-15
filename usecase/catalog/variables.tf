variable "usecase_admin_group" {
  description = "Usecase admin group name"
  type = string
  nullable = false
}

variable "owner" {
  description = "Account admin group name"
  type = string
  nullable = false
}

variable "catalog" {
  description = "Databricks unity catalog catalog name"
  type = string
  nullable = false
}

variable "metastore_id" {
  description = "Databricks unity catalog metastore id"
  type = string
  nullable = false
}
