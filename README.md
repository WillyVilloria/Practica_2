# Practica_2
version 0.0.1
## terraform
Creo infraestructura con terraform.
    - archivo terra.sh --> archivo bash con los comandos terraform para poder ser utilizados por el archivo deploy.sh de ansible
    - archivo acs.tf -- > grupo de recursos (rg).
    - archivo acs.tf -- > container registry (acr).
    - archivo aks.tf --> cluster de kubernetes (aks).
    - archivo vm.tf --> 
        - virtual network.
        - subnet.
        - network interface.
        - public ip.
        - virtual machine (vm).
        - admin de ssh.
        - plan.
        - source image reference.
        - grupo de network security (ngs1).
        - Permito rango de puertos http 8080-8090 para poder tener más de un puerto de acceso.
        - azurerm_subnet_network_security_group_association (ngs-link)
    - archivo imput-vars.tf --> archivo de variables con los nombres y datos necesarios para crear los recursos nombrados en los archivos anteriores.
    - archivo outputs.tf --> archivo con las varibles de salida. 
## ansible
Despliegue con ansible de aplicaciones:
    - archivo deploy.sh --> archivo con comando de consola que realiza las siguientes funciones:
        - llamada al archivo terra.sh para ejecutar los comandos de terraform y realizar el despliegue de la infraestructura comentada anteriormente
        -  una vez terminado el despliegue se realiza la llamada de los playbooks de ansible:
          -  playbook_obtenerlogs.yaml --> ejecuta un comando shell que obtiene las variables de salida definidas en el despliegue de terraform con el archivo outputs.tf, guarda la información en un registro y despuñes lo vuelco a dos archivos diferentes llamados outputs pero uno con formato json y el otro yaml.
          - utilizo el archivo dep_vars.sh básicamente leo las varibles de archivo vars.sjon y utilizo la ip para guardarla en los archivos hosts e inventory y así poder automatizar el despliegue con ansible.
          - playbook_instalarpodman.yaml --> instala la aplicación podman. utilizaré los archivos de variables vars.yaml y el de outputs.json con los datos obtenidos del despliegue de terraform.
          - playbook_instalar.yaml --> instala las aplicaciones y modulos cesarios para realizar la práctica. Destaco la instalación del módulo passlib de python ya que tenía un error en los despliegue en los que se me comunicaba que era imposible exportar este módulo desde el plano de control.
          - playbook_copiar.yaml --> 
              - crea el directorio webserver que es donde se copiarán los archivos necesarios para el despliegue de la aplicación web requerida en la práctica.
              - copio archivo principal de la web -> index.html
              - copio archivo .htacces de configuración de la autenticación.
              - copio archivo httpd.conf con la configuración de un servidor apache2
              - copio archivo Containerfile con la configuración los chivos que se deben volcar en los direcotrios de apache2.
          - playbook_certificados.yaml --> se generan los certificados de seguridad OppenSSL
          - playbook_podmanlogin.yaml -->  se loguea podman con el acr de azure con los datos guardados en el archivo outputs.json.
          - playbook_images.yaml --> 
              - genero imagen
              - tageo la imagen con el nombre de la actividad: casopractico2
              - subo la imagen al acr de azure
              - creo el contenedor para un servidor web
              - inicio el servicio.
          - playbook_imagefor_k8s.yaml --> 
              - obtengo una imagen de nginx desde dockers
              - tageo la imagen con el nombre de la actividad: casopractico2
              - subo la imagen al acr de azure
              - genero el servicio de la aplicación
          - playbook_autenticacion_k8s.yaml --> 
              - a través del shell obtengo las credenciales del cluster de aks
              - creo un namespace
              - creo un servicio con persistencia que consiste:
                - un deployment
                - un persistent volume pv
                - un persistent volume claim
                - un pod asociado al pv
    
    

    # generacion del certificado autofirmado
        *creo clave privada para el certificado
        *creo la peticion de firma del certificado
        *creo certificado utilizando la clave privada y la peticion firmada
        *defino la pagina principal del servidor
        *definir la configuración del servidor web
        *establecer la configuración de autenticación básica
        *Definir el fichero para la creación de la imagen del contenedor
        *Generar la imagen del contenedor
        *Etiquetar la imagen del contenedor
        
        # Subir la imagen del contenedor al registry
            *Autenticarse en el Registry
            *Subir la imagen del contenedor al Registry
            *Crear el contenedor del servicio Web a partir de la imagen creada en el paso anterior
            Generar los ficheros para gestionar el contenedor a través de systemd
            Copiar los ficheros generados en el paso previo al directorio de systemd
            Recargar la configuración de systemd
            Iniciar la aplicación Web desde systemd
            Verificar la conectividad al servidor Web

3 con ansible tengo que preparar la imagen en kubernetes para albergar la app.





# miguel@willy:~$ kubectl get nodes,pods,services,pv,pvc -n practica-k8s
NAME                                   STATUS   ROLES   AGE   VERSION
node/aks-default-41951121-vmss000000   Ready    agent   45m   v1.25.6
node/aks-default-41951121-vmss000001   Ready    agent   45m   v1.25.6

NAME              READY   STATUS    RESTARTS   AGE
pod/task-pv-pod   1/1     Running   0          36m

NAME                 TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
service/pv-jenkins   LoadBalancer   10.0.180.139   20.77.135.110   80:30189/TCP   36m

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                      STORAGECLASS    REASON   AGE
persistentvolume/pvc-6618032e-c91d-4b45-ae5c-23d14519b853   1Gi        RWO            Delete           Bound    practica-k8s/pvc-jenkins   azurefile-csi            35m

NAME                                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
persistentvolumeclaim/pvc-jenkins   Bound    pvc-6618032e-c91d-4b45-ae5c-23d14519b853   1Gi        RWO            azurefile-csi   36m
# miguel@willy:~$ kubectl exec -it task-pv-pod -n practica-k8s -- /bin/bash
# root@task-pv-pod:/# df -h
Filesystem                                                                                Size  Used Avail Use% Mounted on
overlay                                                                                   124G   21G  104G  17% /
tmpfs                                                                                      64M     0   64M   0% /dev
/dev/root                                                                                 124G   21G  104G  17% /etc/hosts
shm                                                                                        64M     0   64M   0% /dev/shm
//fdbf4756fc21b45278d2eaa.file.core.windows.net/pvc-6618032e-c91d-4b45-ae5c-23d14519b853  1.0G     0  1.0G   0% /usr/share/jenkins
tmpfs                                                                                     4.5G   12K  4.5G   1% /run/secrets/kubernetes.io/serviceaccount
tmpfs                                                                                     3.4G     0  3.4G   0% /proc/acpi
tmpfs                                                                                     3.4G     0  3.4G   0% /proc/scsi
tmpfs                                                                                     3.4G     0  3.4G   0% /sys/firmware
# root@task-pv-pod:/# exit
exit
# miguel@willy:~$ ssh casopractico2@51.11.129.209
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Thu Jul 20 14:08:00 2023 from 83.53.24.126
# [casopractico2@vm ~]$ sudo podman images
REPOSITORY                               TAG            IMAGE ID      CREATED         SIZE
localhost/webserver                      latest         69253fb1b8c9  30 minutes ago  173 MB
practica2acr.azurecr.io/jenkins/jenkins  casopractico2  71a575d20b68  38 minutes ago  472 MB
docker.io/jenkins/jenkins                latest         606a8b5a45a1  39 minutes ago  472 MB
practica2acr.azurecr.io/webserver        casopractico2  606a8b5a45a1  39 minutes ago  472 MB
docker.io/library/httpd                  latest         d140b777a247  2 weeks ago     173 MB
# [casopractico2@vm ~]$ sudo podman ps
CONTAINER ID  IMAGE                                                  COMMAND               CREATED         STATUS                 PORTS                   NAMES
fd7956af8772  practica2acr.azurecr.io/jenkins/jenkins:casopractico2  java -jar /usr/sh...  29 minutes ago  Up 49 seconds ago      0.0.0.0:8080->8080/tcp  aplicacion
287e25705c35  practica2acr.azurecr.io/webserver:casopractico2        httpd-foreground      4 minutes ago   Up About a minute ago  0.0.0.0:8090->443/tcp   web


# miguel@willy:~/Documentos/Proyectos/Practica_2/ansible$ chmod +x deploy.sh
# miguel@willy:~/Documentos/Proyectos/Practica_2/ansible$ . deploy.sh
Archivos despliegue de ansible
Archivo creación recursos terraform

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Using previously-installed hashicorp/azurerm v3.37.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_container_registry.acr will be created
  + resource "azurerm_container_registry" "acr" {
      + admin_enabled                 = true
      + admin_password                = (sensitive value)
      + admin_username                = (known after apply)
      + encryption                    = (known after apply)
      + export_policy_enabled         = true
      + id                            = (known after apply)
      + location                      = "uksouth"
      + login_server                  = (known after apply)
      + name                          = "practica2acr"
      + network_rule_bypass_option    = "AzureServices"
      + network_rule_set              = (known after apply)
      + public_network_access_enabled = true
      + resource_group_name           = "practica2rg"
      + retention_policy              = (known after apply)
      + sku                           = "Basic"
      + trust_policy                  = (known after apply)
      + zone_redundancy_enabled       = false
    }

  # azurerm_kubernetes_cluster.aks will be created
  + resource "azurerm_kubernetes_cluster" "aks" {
      + dns_prefix                          = "aks01"
      + fqdn                                = (known after apply)
      + http_application_routing_zone_name  = (known after apply)
      + id                                  = (known after apply)
      + image_cleaner_enabled               = false
      + image_cleaner_interval_hours        = 48
      + kube_admin_config                   = (sensitive value)
      + kube_admin_config_raw               = (sensitive value)
      + kube_config                         = (sensitive value)
      + kube_config_raw                     = (sensitive value)
      + kubernetes_version                  = (known after apply)
      + location                            = "uksouth"
      + name                                = "aks01"
      + node_resource_group                 = (known after apply)
      + oidc_issuer_url                     = (known after apply)
      + portal_fqdn                         = (known after apply)
      + private_cluster_enabled             = false
      + private_cluster_public_fqdn_enabled = false
      + private_dns_zone_id                 = (known after apply)
      + private_fqdn                        = (known after apply)
      + public_network_access_enabled       = true
      + resource_group_name                 = "practica2rg"
      + role_based_access_control_enabled   = true
      + run_command_enabled                 = true
      + sku_tier                            = "Free"
      + tags                                = {
          + "Environment" = "Production"
        }
      + workload_identity_enabled           = false

      + default_node_pool {
          + kubelet_disk_type    = (known after apply)
          + max_pods             = (known after apply)
          + name                 = "default"
          + node_count           = 2
          + node_labels          = (known after apply)
          + orchestrator_version = (known after apply)
          + os_disk_size_gb      = (known after apply)
          + os_disk_type         = "Managed"
          + os_sku               = (known after apply)
          + scale_down_mode      = "Delete"
          + type                 = "VirtualMachineScaleSets"
          + ultra_ssd_enabled    = false
          + vm_size              = "Standard_D2_v2"
          + workload_runtime     = (known after apply)
        }

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }
    }

  # azurerm_linux_virtual_machine.vm will be created
  + resource "azurerm_linux_virtual_machine" "vm" {
      + admin_username                  = "casopractico2"
      + allow_extension_operations      = true
      + computer_name                   = (known after apply)
      + custom_data                     = (sensitive value)
      + disable_password_authentication = true
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "uksouth"
      + max_bid_price                   = -1
      + name                            = "vm"
      + network_interface_ids           = (known after apply)
      + patch_assessment_mode           = "ImageDefault"
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "practica2rg"
      + size                            = "Standard_DS1_v2"
      + virtual_machine_id              = (known after apply)

      + admin_ssh_key {
          + public_key = <<-EOT
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRWmwncgWDtwSn1wGM/4sxRWkJ8cw1xxf2INNt3ysMhyW+8l9MyxN7m24M4cN6cv3IdO3kT/RXCLYWLdldWz+dfF+Y4Mo8oYvB0ZI793zACD34zvJ6eKZV8KjlVJjmt9j5s2NEY1KVYE6Wsh+FbuV/wKew1N2enHmJG1bkIWwXwdAOiJNaztpN3Sf2YWT03QqfEyMCavKmpSttwMrcPj4ZWozG9zndv7SJSEszn5vBSshLeFMNQWlIAFJXEX6tL/ELvDzlcCam/+1JzGcpxGzVYKeBJouXcNC1SqfUHbKPWi5Dqam6GYph8vglR/RF+950YEbXjH+lHtsD1COwmO0ZdHO0IcvDXRZ2uUw17E/SofQhEzER6HBdMyCDqRfYmkdrLjVWxVO7/dmrCA04pEfBMELocw2pI/jfMJNf9yn1jYAB7uJHnSLj9WgaNvb+685kP3r765IZk1TBbjXf/w3trMbneeYofqVIA9OkndOwhAC0sIDqSvNf3xsS/vSoVOc= miguel@willy
            EOT
          + username   = "casopractico2"
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + plan {
          + name      = "centos-8-stream-free"
          + product   = "centos-8-stream-free"
          + publisher = "cognosys"
        }

      + source_image_reference {
          + offer     = "centos-8-stream-free"
          + publisher = "cognosys"
          + sku       = "centos-8-stream-free"
          + version   = "22.03.28"
        }
    }

  # azurerm_network_interface.nic_vm will be created
  + resource "azurerm_network_interface" "nic_vm" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "uksouth"
      + mac_address                   = (known after apply)
      + name                          = "vnic-vm"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "practica2rg"
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + public_ip_address_id                               = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_security_group.nsg1 will be created
  + resource "azurerm_network_security_group" "nsg1" {
      + id                  = (known after apply)
      + location            = "uksouth"
      + name                = "securitygroup"
      + resource_group_name = "practica2rg"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + description                                = ""
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "22"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "sshrule"
              + priority                                   = 101
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
          + {
              + access                                     = "Allow"
              + description                                = ""
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "8080-8090"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "httprule"
              + priority                                   = 102
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
        ]
    }

  # azurerm_public_ip.pip_vm will be created
  + resource "azurerm_public_ip" "pip_vm" {
      + allocation_method       = "Dynamic"
      + ddos_protection_mode    = "VirtualNetworkInherited"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "uksouth"
      + name                    = "public-ip-vm"
      + resource_group_name     = "practica2rg"
      + sku                     = "Basic"
      + sku_tier                = "Regional"
    }

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "uksouth"
      + name     = "practica2rg"
    }

  # azurerm_role_assignment.aksrole will be created
  + resource "azurerm_role_assignment" "aksrole" {
      + id                               = (known after apply)
      + name                             = (known after apply)
      + principal_id                     = (known after apply)
      + principal_type                   = (known after apply)
      + role_definition_id               = (known after apply)
      + role_definition_name             = "AcrPull"
      + scope                            = (known after apply)
      + skip_service_principal_aad_check = true
    }

  # azurerm_subnet.subnet will be created
  + resource "azurerm_subnet" "subnet" {
      + address_prefixes                               = [
          + "10.0.2.0/24",
        ]
      + enforce_private_link_endpoint_network_policies = (known after apply)
      + enforce_private_link_service_network_policies  = (known after apply)
      + id                                             = (known after apply)
      + name                                           = "subnet1"
      + private_endpoint_network_policies_enabled      = (known after apply)
      + private_link_service_network_policies_enabled  = (known after apply)
      + resource_group_name                            = "practica2rg"
      + virtual_network_name                           = "vnet1"
    }

  # azurerm_subnet_network_security_group_association.nsg-link will be created
  + resource "azurerm_subnet_network_security_group_association" "nsg-link" {
      + id                        = (known after apply)
      + network_security_group_id = (known after apply)
      + subnet_id                 = (known after apply)
    }

  # azurerm_virtual_network.vnet will be created
  + resource "azurerm_virtual_network" "vnet" {
      + address_space       = [
          + "10.0.0.0/16",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "uksouth"
      + name                = "vnet1"
      + resource_group_name = "practica2rg"
      + subnet              = (known after apply)
    }

Plan: 11 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + acr_admin_pass     = (sensitive value)
  + acr_admin_user     = (sensitive value)
  + acr_login_server   = (known after apply)
  + client_certificate = (sensitive value)
  + kube_config        = (sensitive value)
  + ssh_user           = "casopractico2"
  + vm_public_ip       = (known after apply)
azurerm_resource_group.rg: Creating...
azurerm_resource_group.rg: Creation complete after 1s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg]
azurerm_virtual_network.vnet: Creating...
azurerm_public_ip.pip_vm: Creating...
azurerm_network_security_group.nsg1: Creating...
azurerm_container_registry.acr: Creating...
azurerm_kubernetes_cluster.aks: Creating...
azurerm_public_ip.pip_vm: Creation complete after 3s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/publicIPAddresses/public-ip-vm]
azurerm_network_security_group.nsg1: Creation complete after 3s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/networkSecurityGroups/securitygroup]
azurerm_virtual_network.vnet: Creation complete after 6s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/virtualNetworks/vnet1]
azurerm_subnet.subnet: Creating...
azurerm_container_registry.acr: Still creating... [10s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [10s elapsed]
azurerm_subnet.subnet: Creation complete after 5s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/subnet1]
azurerm_subnet_network_security_group_association.nsg-link: Creating...
azurerm_network_interface.nic_vm: Creating...
azurerm_subnet_network_security_group_association.nsg-link: Creation complete after 4s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/subnet1]
azurerm_network_interface.nic_vm: Creation complete after 5s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/networkInterfaces/vnic-vm]
azurerm_linux_virtual_machine.vm: Creating...
azurerm_container_registry.acr: Still creating... [20s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [20s elapsed]
azurerm_container_registry.acr: Creation complete after 23s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.ContainerRegistry/registries/practica2acr]
azurerm_linux_virtual_machine.vm: Still creating... [10s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.vm: Still creating... [20s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.vm: Creation complete after 27s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Compute/virtualMachines/vm]
azurerm_kubernetes_cluster.aks: Still creating... [50s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [1m0s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [1m10s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [1m20s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [1m30s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [1m40s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [1m50s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [2m0s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [2m10s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [2m20s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [2m30s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [2m40s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [2m50s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [3m0s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [3m10s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [3m20s elapsed]
azurerm_kubernetes_cluster.aks: Still creating... [3m30s elapsed]
azurerm_kubernetes_cluster.aks: Creation complete after 3m39s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.ContainerService/managedClusters/aks01]
azurerm_role_assignment.aksrole: Creating...
azurerm_role_assignment.aksrole: Still creating... [10s elapsed]
azurerm_role_assignment.aksrole: Still creating... [20s elapsed]
azurerm_role_assignment.aksrole: Creation complete after 26s [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.ContainerRegistry/registries/practica2acr/providers/Microsoft.Authorization/roleAssignments/f8f79836-64f0-782b-a8e0-d9c838d8ab70]

Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

acr_admin_pass = <sensitive>
acr_admin_user = <sensitive>
acr_login_server = "practica2acr.azurecr.io"
client_certificate = <sensitive>
kube_config = <sensitive>
ssh_user = "casopractico2"
vm_public_ip = ""
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg]
azurerm_virtual_network.vnet: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/virtualNetworks/vnet1]
azurerm_public_ip.pip_vm: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/publicIPAddresses/public-ip-vm]
azurerm_container_registry.acr: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.ContainerRegistry/registries/practica2acr]
azurerm_network_security_group.nsg1: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/networkSecurityGroups/securitygroup]
azurerm_kubernetes_cluster.aks: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.ContainerService/managedClusters/aks01]
azurerm_subnet.subnet: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/subnet1]
azurerm_subnet_network_security_group_association.nsg-link: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/subnet1]
azurerm_network_interface.nic_vm: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Network/networkInterfaces/vnic-vm]
azurerm_role_assignment.aksrole: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.ContainerRegistry/registries/practica2acr/providers/Microsoft.Authorization/roleAssignments/f8f79836-64f0-782b-a8e0-d9c838d8ab70]
azurerm_linux_virtual_machine.vm: Refreshing state... [id=/subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/practica2rg/providers/Microsoft.Compute/virtualMachines/vm]

Outputs:

acr_admin_pass = <sensitive>
acr_admin_user = <sensitive>
acr_login_server = "practica2acr.azurecr.io"
client_certificate = <sensitive>
kube_config = <sensitive>
ssh_user = "casopractico2"
vm_public_ip = "20.90.107.110"

PLAY [inicio] ******************************************************************************************************************************

TASK [Ejecutar Terraform] ******************************************************************************************************************
changed: [localhost]

TASK [Crear archivo de outputs json] *******************************************************************************************************
changed: [localhost]

TASK [Crear archivo de outputs yaml] *******************************************************************************************************
changed: [localhost]

TASK [leer una variable de output] *********************************************************************************************************
changed: [localhost]

PLAY RECAP *********************************************************************************************************************************
localhost                  : ok=4    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


20.90.107.110

PLAY [playbook instala podman en vm] *******************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
The authenticity of host '20.90.107.110 (20.90.107.110)' can't be established.
ECDSA key fingerprint is SHA256:oEfRFVXdlaAENmaEUsdXiR6tGoBkwRcL3l1+wrqvGpw.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [20.90.107.110]

TASK [instalo podman] **********************************************************************************************************************
changed: [20.90.107.110]

PLAY RECAP *********************************************************************************************************************************
20.90.107.110              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


PLAY [playbook instala aplicaciones en vm] *************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [20.90.107.110]

TASK [cambio zonahoraria] ******************************************************************************************************************
changed: [20.90.107.110]

TASK [instalo httpd] ***********************************************************************************************************************
changed: [20.90.107.110]

TASK [instalo openssl] *********************************************************************************************************************
ok: [20.90.107.110]

TASK [Instalar passlib en el host remoto] **************************************************************************************************
changed: [20.90.107.110]

PLAY RECAP *********************************************************************************************************************************
20.90.107.110              : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


PLAY [playbook copia los archivos del directorio /file] ************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [20.90.107.110]

TASK [Create a directory if it does not exist] *********************************************************************************************
changed: [20.90.107.110]

TASK [Copy file index.html] ****************************************************************************************************************
changed: [20.90.107.110]

TASK [Copy file ansible/files/.htaccess] ***************************************************************************************************
changed: [20.90.107.110]

TASK [Copy file ansible/files/httpd.conf] **************************************************************************************************
changed: [20.90.107.110]

TASK [Copy file ansible/files/Containerfile] ***********************************************************************************************
changed: [20.90.107.110]

PLAY RECAP *********************************************************************************************************************************
20.90.107.110              : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


PLAY [Generar certificados] ****************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [20.90.107.110]

TASK [Generate file htpasswd] **************************************************************************************************************
changed: [20.90.107.110]

TASK [Generate an OpenSSL private key with a different size (2048 bits)] *******************************************************************
changed: [20.90.107.110]

TASK [Generate an OpenSSL Certificate Signing Request] *************************************************************************************
changed: [20.90.107.110]

TASK [Generate a Self Signed OpenSSL certificate] ******************************************************************************************
changed: [20.90.107.110]

PLAY RECAP *********************************************************************************************************************************
20.90.107.110              : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


PLAY [playbook login podman with acr] ******************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [20.90.107.110]

TASK [Login to default registry with outputs.json] *****************************************************************************************
changed: [20.90.107.110]

PLAY RECAP *********************************************************************************************************************************
20.90.107.110              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


PLAY [playbook despliegue'] ****************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [20.90.107.110]

TASK [Build a basic image] *****************************************************************************************************************
changed: [20.90.107.110]

TASK [containers.podman.podman_tag] ********************************************************************************************************
changed: [20.90.107.110]

TASK [Build and push an image using existing credentials] **********************************************************************************
changed: [20.90.107.110]

TASK [Create a webserver container] ********************************************************************************************************
changed: [20.90.107.110]

TASK [Iniciar servicio de web] *************************************************************************************************************
changed: [20.90.107.110]

PLAY RECAP *********************************************************************************************************************************
20.90.107.110              : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


PLAY [playbook despliegue para k8s] ********************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [20.90.107.110]

TASK [Create a directory if it does not exist] *********************************************************************************************
changed: [20.90.107.110]

TASK [Copy file ansible/files_k8s/Containerfile] *******************************************************************************************
changed: [20.90.107.110]

TASK [Pull an image] ***********************************************************************************************************************
changed: [20.90.107.110]

TASK [containers.podman.podman_tag] ********************************************************************************************************
changed: [20.90.107.110]

TASK [Build and push an image using existing credentials] **********************************************************************************
changed: [20.90.107.110]

TASK [Run container] ***********************************************************************************************************************
changed: [20.90.107.110]

PLAY RECAP *********************************************************************************************************************************
20.90.107.110              : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


PLAY [Autenticacion kubernetes] ************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [localhost]

TASK [Instalar kubernetes] *****************************************************************************************************************
ok: [localhost]

TASK [credenciales aks] ********************************************************************************************************************
changed: [localhost]

TASK [Create a k8s namespace] **************************************************************************************************************
changed: [localhost]

TASK [Create a persistant service from a local file] ***************************************************************************************
changed: [localhost]

PLAY RECAP *********************************************************************************************************************************
localhost                  : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   



