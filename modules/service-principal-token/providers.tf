terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.2.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
  }
}
