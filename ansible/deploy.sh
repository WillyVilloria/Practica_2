#!/bin/bash
echo "Archivo despliegue de ansible"

#ansible-playbook -i inventory 00_playbook.yaml

ansible-playbook -i inventory -vvv playbook.yaml

#ansible-galaxy init role_01 --init-path roles/