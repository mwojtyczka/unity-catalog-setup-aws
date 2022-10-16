resource "databricks_grants" "storage_credential" {
  storage_credential = databricks_storage_credential.this.id

  grant {
    principal = var.usecase_admin_group
    privileges = [
      "CREATE_TABLE"
    ]
  }

  grant {
    principal  = var.owner
    privileges = [
      "CREATE_TABLE"
    ]
  }

  provider = databricks
}

resource "databricks_grants" "external_location" {
  external_location = databricks_external_location.this.id

  grant {
    principal = var.usecase_user_group
    privileges = [
      "READ_FILES",
      "WRITE_FILES"
    ]
  }

  grant {
    principal = var.usecase_admin_group
    privileges = [
      "CREATE_TABLE",
      "READ_FILES",
      "WRITE_FILES"
    ]
  }

  grant {
    principal = var.owner
    privileges = [
      "CREATE_TABLE",
      "READ_FILES",
      "WRITE_FILES"
    ]
  }

  provider = databricks
}
