#!/bin/bash
echo "Archivos despliegue de ansible"

/home/miguel/Documentos/Proyectos/Practica_2/terraform/terra.sh
ansible-playbook -i inventory -vvv playbook_obtenerlogs.yaml

#ansible-playbook -i inventory playbook_instalar.yaml
#ansible-playbook -i inventory playbook_certificados.yaml
#ansible-playbook -i inventory playbook_copiar.yaml



