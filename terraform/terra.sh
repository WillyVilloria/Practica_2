#!/bin/bash
echo "Archivo creación recursos terraform"

terraform init
terraform apply -auto-approve
terraform refresh