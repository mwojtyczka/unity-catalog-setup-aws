resource "databricks_metastore" "uc" {
  name = var.metastore_name
  storage_root = "s3://${aws_s3_bucket.unity_metastore.bucket}"
  force_destroy = true

  owner = var.owner

  lifecycle {
    prevent_destroy = true
  }

  provider = databricks
}

resource "databricks_metastore_data_access" "default" {
  metastore_id = databricks_metastore.uc.id
  name = "default"
  is_default = true

  aws_iam_role {
    role_arn = aws_iam_role.unity_metastore.arn
  }

  lifecycle {
    prevent_destroy = true
  }

  provider = databricks
  depends_on = [databricks_metastore_assignment.default]
}

resource "databricks_metastore_assignment" "default" {
  for_each = toset(var.workspace_ids)
  workspace_id = each.key
  metastore_id = databricks_metastore.uc.id

  lifecycle {
    prevent_destroy = true
  }
  provider = databricks
}
