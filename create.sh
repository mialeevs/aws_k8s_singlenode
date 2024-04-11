#!/bin/bash
#
MY_IP=$(curl -s https://api.ipify.org)

terraform init

terraform fmt

terraform apply -var="my_ip=${MY_IP}" --auto-approve

chmod 400 tempkey.pem
