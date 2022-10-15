resource "databricks_storage_credential" "this" {
  name = local.storage_credential
  aws_iam_role {
    role_arn = var.data_role_arn
  }
  comment = "Managed by terraform"

  provider = databricks
  owner = var.owner
}

resource "databricks_external_location" "this" {
  name = local.external_location
  url = "s3://${var.data_bucket}"
  credential_name = databricks_storage_credential.this.name
  comment= "Managed by terraform"

  provider = databricks
  owner = var.owner
}
