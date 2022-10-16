locals {
  external_location = var.data_bucket
  storage_credential = "sc-${var.data_bucket}"
}
