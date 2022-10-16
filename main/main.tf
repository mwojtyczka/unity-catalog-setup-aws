// create account admin group in the account (optional - if not scim provisioned from IdP)
module "account_admin_group" {
  source = "../modules/account/group"

  group_name = var.account_admin_group

  providers = {
    databricks = databricks.account
  }
}

// assign admin users to account admin group
module "group_members" {
  source = "../modules/account/group-members"

  for_each = toset(var.account_admin_group_users)

  group_id = module.account_admin_group.id
  user_name = each.key

  providers = {
    databricks = databricks.account
  }
}

// create usecase admin groups in the account console (optional - if not scim provisioned from IdP)
module "usecase_admin_group" {
  source = "../modules/account/group"

  # create a group for each workspace
  for_each = { for record in local.usecases : record.prefix => record }

  group_name = each.value.usecase_admin_group

  providers = {
    databricks = databricks.account
  }
}

// create usecase user groups in the account console (optional - if not scim provisioned from IdP)
module "usecase_user_group" {
  source = "../modules/account/group"

  # create a group for each workspace
  for_each = { for record in local.usecases : record.prefix => record }

  group_name = each.value.usecase_user_group

  providers = {
    databricks = databricks.account
  }
}

// create service principals in the account for each use case
module "service_principals" {
  source = "../modules/account/service-principal"

  for_each = { for record in local.usecases : record.prefix => record }

  sp_name = each.value.service_principal
  # add service principal to the usecase admin group
  # once the admin group is assigned to a workspace, the sp will be synced to the workspace automatically
  group_to_assign = each.value.usecase_admin_group

  providers = {
    databricks = databricks.account
  }

  depends_on = [
    module.usecase_admin_group
  ]
}

// create unity catalog metastore
module "metastore" {
  source = "../modules/metastore"

  metastore_name = var.metastore_name
  metastore_role_name = var.metastore_role_name
  metastore_bucket_name = var.metastore_bucket_name
  workspace_ids = local.workspace_ids
  owner = var.account_admin_group
  databricks_account_id = var.databricks_account_id

  providers = {
    databricks = databricks.workspace,
    aws = aws.uc
  }

  depends_on = [
    module.account_admin_group
  ]
}

// assign usecase user group to workspaces
module "assign_usecase_user_group_to_workspaces" {
  source = "../modules/account/assign-group-to-workspace"

  for_each = { for record in local.usecases : record.prefix => record }

  workspace_id = each.value.workspace_id
  group = each.value.usecase_user_group
  is_admin = false

  providers = {
    databricks = databricks.account
  }

  depends_on = [
    module.metastore,
    module.usecase_user_group
  ]
}

// assign usecase admin group to workspaces
module "assign_usecase_admin_group_to_workspaces" {
  source = "../modules/account/assign-group-to-workspace"

  for_each = { for record in local.usecases : record.prefix => record }

  workspace_id = each.value.workspace_id
  group = each.value.usecase_admin_group
  is_admin = true

  providers = {
    databricks = databricks.account
  }

  depends_on = [
    module.metastore,
    module.usecase_admin_group
  ]
}

// assign account admin group to all workspaces
module "assign_account_admin_group_to_workspaces" {
  source = "../modules/account/assign-group-to-workspace"

  for_each = { for record in local.usecases : record.prefix => record }

  workspace_id = each.value.workspace_id
  group = var.account_admin_group
  is_admin = true

  providers = {
    databricks = databricks.account
  }

  depends_on = [
    module.metastore,
    module.account_admin_group
  ]
}

// create external locations and storage credentials for each use case
module "files" {
  source = "../modules/usecase/file"

  for_each = { for record in local.usecases : record.prefix => record }

  usecase_admin_group = each.value.usecase_admin_group
  usecase_user_group = each.value.usecase_user_group
  data_bucket = each.value.data_bucket
  data_role_arn = each.value.data_role_arn
  owner = var.account_admin_group

  providers = {
    databricks = databricks.workspace
  }

  depends_on = [
    module.metastore,
    module.usecase_admin_group,
    module.usecase_user_group
  ]
}

// create a catalog for each use case
module "catalogs" {
  source = "../modules/usecase/catalog"

  for_each = { for record in local.usecases : record.prefix => record }

  usecase_admin_group = each.value.usecase_admin_group
  catalog = each.value.catalog
  metastore_id = module.metastore.id
  owner = var.account_admin_group

  providers = {
    databricks = databricks.workspace
  }

  depends_on = [
    module.metastore,
    module.usecase_admin_group,
    module.usecase_user_group
  ]
}
