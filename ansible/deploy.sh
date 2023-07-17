#!/bin/bash
echo "Archivos despliegue de ansible"

cd ../terraform
/home/miguel/Documentos/Proyectos/Practica_2/terraform/terra.sh

cd ../ansible
ansible-playbook -i inventory playbook_obtenerlogs.yaml

chmod +x vars.sh
./vars.sh

#ansible-playbook -i inventory playbook_instalar.yaml
#ansible-playbook -i inventory playbook_copiar.yaml
#ansible-playbook -i inventory playbook_certificados.yaml
#ansible-playbook -i inventory playbook_podmanlogin.yaml
#ansible-playbook -i inventory playbook_images.yaml

#az aks get-credentials --name aks01 --resource-group practica2rg --overwrite-existing

#ANSIBLE_LIBRARY=/usr/lib/python3/dist-packages/kubernetes ansible-playbook -i inventory -vvv playbook_autenticacion_k8s.yaml 
ansible-playbook -i inventory -vvv playbook_autenticacion_k8s.yaml 

