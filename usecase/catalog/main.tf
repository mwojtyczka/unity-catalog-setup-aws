resource "databricks_catalog" "this" {
  metastore_id = var.metastore_id
  name = var.catalog

  comment = "Catalog managed by ${var.usecase_admin_group} group"

  provider = databricks
  owner = var.owner

  // TODO specify LOCATION for Managed Tables in the catalog once the feature is available in Unity Catalog
}
