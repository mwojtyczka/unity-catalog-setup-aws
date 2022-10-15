// create service principal
resource "databricks_service_principal" "sp" {
  provider = databricks
  display_name = var.sp_name
}

// assign service principal to usecase admin group
resource "databricks_group_member" "group_member" {
  provider  = databricks
  group_id  = data.databricks_group.usecase_admin.id
  member_id = databricks_service_principal.sp.id
}

data "databricks_group" "usecase_admin" {
  display_name = var.group_to_assign
  provider = databricks
}
