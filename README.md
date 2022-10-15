# Unity Catalog Setup on AWS

This repository contains an example of end to end unity catalog deployment with terraform on aws. 
As part of the deployment Databricks unity catalog resources and required AWS resources are created.

## Configuration

There are two configuration files that you should adjust prior to running the terraform code:

1. `main/config.tfvars` - contains the main deployment configuration
2. `main/backend.conf` - contains backend configuration for storing the terraform state files

## Setup

1. Install databricks CLI: https://docs.databricks.com/dev-tools/cli/index.html#install-the-cli
2. Install the latest terraform CLI: https://learn.hashicorp.com/tutorials/terraform/install-cli
3. Create aws profile called `uc` for the aws account where uc metastore (bucket, iam role) should be created: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
3. Store databricks credentials in AWS Secret Manager of the `uc` aws account:
    * account console credentials: store username and password in `databricks/account_owner_credentials` secret. 
      If SSO is enabled for the account console, you have to provide account owner/root credentials!
      Token based authentication for the account console will be available in the future.
    * workspace token: generate PAT token for your user in any of your workspaces and store it in `databricks/workspace_token` secret.
4. Create S3 bucket and IAM role for use cases as configured in the `main/config.tfvars` (see `data_bucket` and `data_role_arn`): 
   https://docs.databricks.com/data-governance/unity-catalog/manage-external-locations-and-credentials.html
   
## Usage

1. Run terraform plan: ./deploy.sh
2. Deploy resources: ./deploy.sh apply

## Repo structure

```
.
├── main                     # Main code that run the individual terraform modules
├── metastore                # Terraform module for deploying metastore and required aws resources (S3 bucket, IAM role)
├── usecase                  # A set of terraform modules for deploying use case specific unity catalog objects, e.g. catalogs, storage credentials, external locations
├── account                  # A set of terraform modules for deploying account objects, e.g. groups, service principals
├── service-principal-token  # Terraform module for creating service principal token and store in aws secret manager
├── deploy.sh                # Script that can be used for running the terraform code and deploying the resources
├── LICENSE
└── README.md
```

## Design decisions

The following design decisions are applied as part of the deployment:

* One Databricks account is used
* One Unity Catalog metastore for all workspaces is created. If you have workspaces located in multiple aws regions, you will have to create a separate metastore for each region!
* One catalog, storage credential, external location for each use case and environment is created: `<usecase>_<environment>`
* One set of groups for each use case and environment is created: `admin_<usecase>_<environment>` (owner of databases and tables), `user_<usecase>_<environment>` (users with default usage/view access to a use case catalog)
* One account admin group for platform team is created. The group is used as owner for all unity catalog objects, e.g. catalogs, external locations, storage credentials etc.
* One Service Principal (sp) for automation is created for each use case and environment: `sp_<usecase>_<environment>`
* Use case teams are responsible for creating one unity catalog compatible S3 bucket and IAM role for external locations / tables. This could optionally be done as part of this deployment as well.
* Use case teams are responsible for providing LOCATION when creating external tables so that the data lands in the correct use case S3 buckets
(in the future it will be possible to specify LOCATION at the catalog level for managed tables so platform team will be able to manage this for the use case teams)
  
## Resources created and actions performed as of this terraform deployment

* Create account admin group in the databricks account console. Not needed if provisioned via SCIM from IdP.
* Assign predefined admin users (in `main/config.tfvars`) to the account admin group
* Create admin group in the account console for each use case. Not needed if provisioned via SCIM from IdP.
* Create user group in the account console for each use case. Not needed if provisioned via SCIM from IdP.
* Create service principal in the account for each use case and add it to the use case admin group.
* Create unity catalog metastore and create the required AWS resources (metastore S3 bucket and IAM role)
* Assign use case user and admin groups to the respective workspaces
* Assign account admin group to all workspaces
* Create external locations and storage credentials for each use case. Buckets and IAM roles for the external locations are not part of this deployment. 
* Create catalog for each use case

If you want to get more details, have a look inside `main/main.tf` file.
