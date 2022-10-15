output "id" {
  value = databricks_service_principal.sp.id
}

output "name" {
  value = databricks_service_principal.sp.display_name
}

output "application_id" {
  value = databricks_service_principal.sp.application_id
}
