#!/bin/bash

set -ex 

APPLY=$1

cd ../main

terraform init -backend-config backend.conf -backend-config "profile=uc"
terraform plan -var-file=config.tfvars

if [[ $APPLY = 'apply' ]]; then
    terraform apply -auto-approve -var-file=config.tfvars
fi

terraform output -json
