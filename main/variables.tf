//
// Authentication variables
//

variable "aws_profile" {
    description = "AWS sign-in profile"
    default = "uc"
}

variable "workspace_host" {
  description = "Host for a databricks workspace (this can be url for any of your databricks workspaces)"
  type = string
  default = "https://test.cloud.databricks.com/"
}

//
// variables defined in tfvars
//

variable "databricks_account_id" {
  description = "Databricks account id"
  type = string
  nullable = false
}

variable "metastore_name" {
  description = "Databricks unity catalog metastore name"
  type = string
  nullable = false
}

variable "metastore_bucket_name" {
  description = "Databricks unity catalog metastore bucket name"
  type = string
  nullable = false
}

variable "metastore_role_name" {
  description = "Databricks unity catalog metastore iam role name"
  type = string
  nullable = false
}

variable "account_admin_group" {
  description = "Account admin group name"
  type = string
  nullable = false
}

variable "account_admin_group_users" {
  description = "List of user ids that should belong to account admins group"
  type = list(string)
}

variable "usecases" {
  description = "Main configuration object holding all mappings for use cases, workspaces and environments"
  type = list(object({
    name = string
    environment = string
    workspace_name = string
    data_role_arn = string
    data_bucket = string
  }))
}

variable "workspace_name_to_id_map" {
  description = "Mappings from workspace names to workspace ids"
  type = map(string)
}
