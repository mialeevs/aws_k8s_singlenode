#!/bin/bash
#
MY_IP=$(curl -s https://api.ipify.org)

terraform destroy -var="my_ip=${MY_IP}" --auto-approve

rm -f tempkey.pem
