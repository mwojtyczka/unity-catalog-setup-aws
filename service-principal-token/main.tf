// create token
resource "databricks_obo_token" "sp_token" {
  application_id = var.sp_id
  lifetime_seconds = var.token_lifetime_seconds
  comment = "token for service principal of usecase ${var.usecase_name} and environment ${var.environment}"
  provider = databricks
}

// load the token into secrets manager
resource "aws_secretsmanager_secret" "sp_token" {
    name = "databricks/${var.environment}/sp-token/${var.usecase_name}"
    provider = aws
}

resource "aws_secretsmanager_secret_version" "sp_token" {
    secret_id = aws_secretsmanager_secret.sp_token.id
    secret_string = databricks_obo_token.sp_token.token_value
    provider = aws
}

resource "databricks_permissions" "token_usage" {
  authorization = "tokens"
  access_control {
    service_principal_name = var.sp_id
    permission_level = "CAN_USE"
  }
  provider = databricks
}
