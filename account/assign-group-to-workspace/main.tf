resource "databricks_mws_permission_assignment" "account_admin" {
  workspace_id = var.workspace_id
  principal_id = data.databricks_group.this.id
  permissions  = [(var.is_admin ? "ADMIN" : "USER")]
  provider = databricks
}

data "databricks_group" "this" {
  display_name = var.group
  provider = databricks
}
