terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "1.2.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "4.29.0"
    }
  }
}

provider "aws" {
  alias = "uc"
  region = "eu-west-1"
  profile = var.aws_profile
}

provider "databricks" {
  alias = "account"
  host = "https://accounts.cloud.databricks.com/"
  account_id = var.databricks_account_id
  # TODO if SSO is enabled for the account console the account owner/root is needed here!
  # This can be fixed once token based access is supported in the account console
  username = jsondecode(data.aws_secretsmanager_secret_version.account_credentials.secret_string)["user"]
  password = jsondecode(data.aws_secretsmanager_secret_version.account_credentials.secret_string)["password"]
}

# define workspace provider through which UC resources will be deployed
# this can be any workspace as long as the account admin user that you use has access to it
provider "databricks" {
  alias = "workspace"
  host = var.workspace_host
  # the token has to be generated for a user that is an account admin
  token = jsondecode(data.aws_secretsmanager_secret_version.workspace_token.secret_string)["token"]
}

data "aws_secretsmanager_secret_version" "account_credentials" {
  secret_id = data.aws_secretsmanager_secret.account_credentials.id
  provider = aws.uc
}

data "aws_secretsmanager_secret" "account_credentials" {
  name = "databricks/account_owner_credentials"
  provider = aws.uc
}

data "aws_secretsmanager_secret_version" "workspace_token" {
  secret_id = data.aws_secretsmanager_secret.workspace_token.id
  provider = aws.uc
}

data "aws_secretsmanager_secret" "workspace_token" {
  name = "databricks/workspace_token"
  provider = aws.uc
}
