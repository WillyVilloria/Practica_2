#!/bin/bash
echo "Archivos despliegue de ansible"

cd ../ansible

#az aks get-credentials --name aks01 --resource-group practica2rg --overwrite-existing

#ANSIBLE_LIBRARY=/usr/lib/python3/dist-packages/kubernetes ansible-playbook -i inventory -vvv playbook_autenticacion_k8s.yaml 
ansible-playbook -i inventory playbook_autenticacion_k8s.yaml 
