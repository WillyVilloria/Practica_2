#!/bin/bash

ip=$(jq '.vm_public_ip.value' vars/outputs.json)
user=$(jq '.acr_admin_user.value' vars/outputs.json)
pass=$(jq '.acr_admin_pass.value' vars/outputs.json)
sshuser=$(jq '.ssh_user.value' vars/outputs.json)

echo $json_data
clean_ip=$(echo "$ip" | tr -d '"')
clean_user=$(echo "$user" | tr -d '"')
clean_pass=$(echo "$pass" | tr -d '"')
clean_sshuser=$(echo "$sshuser" | tr -d '"')
echo $clean_ip

echo "$clean_ip" > hosts

cat <<EOF > inventory
[webservers]
$clean_ip 

[terraform_host]
localhost ansible_connection=local
EOF