#!/bin/bash
set -u

if [ -d ".terraform" ]; then
  rm -r .terraform
fi

terraform fmt -recursive
terraform init
terraform apply
