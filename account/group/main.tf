resource "databricks_group" "this" {
  display_name = var.group_name
  provider = databricks

  lifecycle {
    prevent_destroy = true
  }
}
