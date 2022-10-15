data "databricks_user" "user" {
  user_name = var.user_name
  provider = databricks
}

resource "databricks_group_member" "group_member" {
  provider  = databricks
  group_id  = var.group_id
  member_id = data.databricks_user.user.id
}
