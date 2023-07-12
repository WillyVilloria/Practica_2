#!/bin/bash
echo "Archivos despliegue de ansible"

#cd /home/miguel/Documentos/Proyectos/Practica_2/terraform
#/home/miguel/Documentos/Proyectos/Practica_2/terraform/terra.sh

#cd /home/miguel/Documentos/Proyectos/Practica_2/ansible
#ansible-playbook -i inventory playbook_obtenerlogs.yaml

#chmod +x vars.sh
#./vars.sh

#ansible-playbook -i inventory playbook_instalar.yaml
#ansible-playbook -i inventory playbook_copiar.yaml
#ansible-playbook -i inventory playbook_certificados.yaml
ansible-playbook -i inventory playbook_podmanlogin.yaml
ansible-playbook -i inventory playbook_images.yaml


