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
        - Permito rango de puertos http 8080-8090 para poder tener más de un puerto de acceso ya que voy a tener dos aplicaciones en funcionamiento a la vez.
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
              - tageo la imagen con el nombre de la actividad
              - subo la imagen al acr de azure
              - creo el contenedor para un servidor web
              - inicio el servicio.
          - playbook_imagefor_k8s.yaml --> 
              - obtengo una imagen de nginx desde dockers
              - tageo la imagen con el nombre de la actividad
              - subo la imagen al acr de azure
              - genero el servicio de la aplicación
              - inicio el servicio.
          - playbook_autenticacion_k8s.yaml -->
    
    

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
[casopractico2@vm ~]$ 


