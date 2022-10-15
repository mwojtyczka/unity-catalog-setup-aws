resource "databricks_mws_permission_assignment" "account_admin" {
  workspace_id = var.workspace_id
  principal_id = var.sp_id
  permissions  = [(var.is_admin ? "ADMIN" : "USER")]
  provider = databricks
}
