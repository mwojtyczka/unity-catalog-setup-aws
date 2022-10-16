resource "databricks_grants" "catalog" {
  catalog = databricks_catalog.this.id

  grant {
    // All users will be able to see catalogs and determine who is managing it
    // Objects inside like dbs and tables will not be visible
    principal  = "account users"
    privileges = [
      "USAGE"
    ]
  }

  grant {
    principal  = var.usecase_admin_group
    privileges = [
      "USAGE",
      "CREATE"
    ]
  }

  grant {
    principal  = var.owner
    privileges = [
      "USAGE",
      "CREATE"
    ]
  }

  provider = databricks
}

