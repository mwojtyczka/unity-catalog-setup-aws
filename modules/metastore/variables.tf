variable "metastore_name" {
  description = "Databricks unity catalog metastore name"
  type = string
  nullable = false
}

variable "metastore_role_name" {
  description = "Databricks unity catalog iam role name"
  type = string
  nullable = false
}

variable "metastore_bucket_name" {
  description = "Databricks Unity catalog matastore bucket name"
  type = string
  nullable = false
}

variable "databricks_account_id" {
  description = "Databricks account id"
  type = string
  nullable = false
}

variable "workspace_ids" {
  description = "List of Databricks workspace ids to be enabled with Unity Catalog"
  type = list(string)
}

variable "owner" {
  description = "Metastore owner"
  type = string
  nullable = false
}
