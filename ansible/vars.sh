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
# pruebo esta forma
echo "$clean_ip" > hosts
#cat <<EOF > hosts
#$clean_ip
#EOF

cat <<EOF > inventory
[webservers]
$clean_ip nombre_dominio=webserver.example.com ip_interna=10.0.2.4

[databases]
$clean_ip nombre_dominio=database.example.com ip_interna=10.0.2.5

[terraform_host]
localhost ansible_connection=local
EOF

#ssh $clean_sshuser@$clean_ip