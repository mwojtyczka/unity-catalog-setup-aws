locals {
  usecases = flatten([
    for usecase in var.usecases : [
      {
        name = usecase.name
        workspace_id = var.workspace_name_to_id_map[usecase.workspace_name]
        workspace_name = usecase.workspace_name
        data_role_arn = usecase.data_role_arn
        data_bucket = usecase.data_bucket
        prefix = "${usecase.name}_${usecase.environment}"
        environment = usecase.environment

        catalog = replace("${usecase.name}_${usecase.environment}", "-", "_") # avoid escaping "-" sign
        usecase_admin_group = replace("admin_${usecase.name}_${usecase.environment}", "-", "_")
        usecase_user_group = replace("user_${usecase.name}_${usecase.environment}", "-", "_")
        service_principal = replace("sp-${usecase.name}_${usecase.environment}", "-", "_")
      }
    ]
  ])

  workspace_ids = distinct([for x in local.usecases : x.workspace_id])
}
