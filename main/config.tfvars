metastore_name = "companyA-uc-eu-west-1"
metastore_bucket_name = "companyA-databricks-uc-metastore-root-eu-west-1"
metastore_role_name = "companyA-databricks-role-uc-metastore-eu-west-1"

databricks_account_id = "00000000-0000-0000-0000-000000000000" # as per your databricks account id

account_admin_group = "account_admin"
account_admin_group_users = [
  # define account admin users here
  "user@databricks.com",
  # add more admins here
]

workspace_name_to_id_map = {
  # define workspace ids
  dev1 = "100000000000000"
  /*dev2 = "200000000000000"
  qa = "300000000000000"
  prod = "400000000000000"
  */
}

# define business use cases and their configuration
# Each use case will get a separate admin & user group, sp, catalog, storage credential and external location
usecases = [
  {
    name = "usecase1"
    environment = "dev"
    workspace_name = "dev1"
    # data role as per https://docs.databricks.com/data-governance/unity-catalog/get-started.html#configure-a-storage-bucket-and-iam-role-in-aws
    data_role_arn = "arn:aws:iam::11111111111:role/companyA-role-uc-external-location-uc-dev"
    data_bucket = "companyA-uc-dev"
  }
  /*,
  {
    name = "usecase2"
    environment = "dev"
    workspace_name = "dev2"
    data_role_arn = "arn:aws:iam::11111111111:role/companyA-role-uc-external-location-uc-dev"
    data_bucket = "companyA-uc-dev"
  },
  {
    name = "usecase1"
    environment = "qa"
    workspace_name = "qa"
    data_role_arn = "arn:aws:iam::2222222222:role/companyA-role-uc-external-location-qa"
    data_bucket = "companyA-uc-qa"
  },
  {
    name = "usecase1"
    environment = "prod"
    workspace_name = "prod"
    data_role_arn = "arn:aws:iam::33333333333:role/companyA-role-uc-external-location-prod"
    data_bucket = "companyA-uc-prod"
  }*/
]
