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
2 con ansible tengo que preparar la imagen de podman para albergar la web
    * instalo podman
    * instalo skopeo
    * instalo httpd-tools
    * instalo openssl
    * Creo el directorio webserver
    creo el fichero de credenciales .creds

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


miguel@willy:~$ kubectl describe node aks-default-41951121-vmss000000
Name:               aks-default-41951121-vmss000000
Roles:              agent
Labels:             agentpool=default
                    beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/instance-type=Standard_D2_v2
                    beta.kubernetes.io/os=linux
                    failure-domain.beta.kubernetes.io/region=uksouth
                    failure-domain.beta.kubernetes.io/zone=0
                    kubernetes.azure.com/agentpool=default
                    kubernetes.azure.com/cluster=MC_practica2rg_aks01_uksouth
                    kubernetes.azure.com/consolidated-additional-properties=d0438adf-26ef-11ee-a7f7-564b98600cf9
                    kubernetes.azure.com/kubelet-identity-client-id=98030437-8015-4c74-bf64-fd493fd7d66e
                    kubernetes.azure.com/mode=system
                    kubernetes.azure.com/node-image-version=AKSUbuntu-2204containerd-202307.04.0
                    kubernetes.azure.com/nodepool-type=VirtualMachineScaleSets
                    kubernetes.azure.com/os-sku=Ubuntu
                    kubernetes.azure.com/role=agent
                    kubernetes.azure.com/storageprofile=managed
                    kubernetes.azure.com/storagetier=Standard_LRS
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=aks-default-41951121-vmss000000
                    kubernetes.io/os=linux
                    kubernetes.io/role=agent
                    node-role.kubernetes.io/agent=
                    node.kubernetes.io/instance-type=Standard_D2_v2
                    storageprofile=managed
                    storagetier=Standard_LRS
                    topology.disk.csi.azure.com/zone=
                    topology.kubernetes.io/region=uksouth
                    topology.kubernetes.io/zone=0
Annotations:        csi.volume.kubernetes.io/nodeid:
                      {"disk.csi.azure.com":"aks-default-41951121-vmss000000","file.csi.azure.com":"aks-default-41951121-vmss000000"}
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Thu, 20 Jul 2023 13:25:46 +0200
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  aks-default-41951121-vmss000000
  AcquireTime:     <unset>
  RenewTime:       Thu, 20 Jul 2023 14:19:39 +0200
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Thu, 20 Jul 2023 13:27:45 +0200   Thu, 20 Jul 2023 13:27:45 +0200   RouteCreated                 RouteController created a route
  MemoryPressure       False   Thu, 20 Jul 2023 14:16:37 +0200   Thu, 20 Jul 2023 13:25:46 +0200   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure         False   Thu, 20 Jul 2023 14:16:37 +0200   Thu, 20 Jul 2023 13:25:46 +0200   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure          False   Thu, 20 Jul 2023 14:16:37 +0200   Thu, 20 Jul 2023 13:25:46 +0200   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready                True    Thu, 20 Jul 2023 14:16:37 +0200   Thu, 20 Jul 2023 13:25:56 +0200   KubeletReady                 kubelet is posting ready status. AppArmor enabled
Addresses:
  InternalIP:  10.224.0.4
  Hostname:    aks-default-41951121-vmss000000
Capacity:
  cpu:                2
  ephemeral-storage:  129886128Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             7098320Ki
  pods:               110
Allocatable:
  cpu:                1900m
  ephemeral-storage:  119703055367
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             4653008Ki
  pods:               110
System Info:
  Machine ID:                 35f3d55a0c514a628c1a2ca4728677b6
  System UUID:                b1ae6e4f-9dec-d548-b294-e7f29a0f6128
  Boot ID:                    9d89e8d3-2743-4e35-b99c-bc046a43025a
  Kernel Version:             5.15.0-1041-azure
  OS Image:                   Ubuntu 22.04.2 LTS
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://1.7.1+azure-1
  Kubelet Version:            v1.25.6
  Kube-Proxy Version:         v1.25.6
PodCIDR:                      10.244.1.0/24
PodCIDRs:                     10.244.1.0/24
ProviderID:                   azure:///subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/mc_practica2rg_aks01_uksouth/providers/Microsoft.Compute/virtualMachineScaleSets/aks-default-41951121-vmss/virtualMachines/0
Non-terminated Pods:          (7 in total)
  Namespace                   Name                                   CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                   ------------  ----------  ---------------  -------------  ---
  kube-system                 azure-ip-masq-agent-dsxvl              100m (5%)     500m (26%)  50Mi (1%)        250Mi (5%)     54m
  kube-system                 cloud-node-manager-7nhbl               50m (2%)      0 (0%)      50Mi (1%)        512Mi (11%)    54m
  kube-system                 csi-azuredisk-node-bk9lw               30m (1%)      0 (0%)      60Mi (1%)        400Mi (8%)     54m
  kube-system                 csi-azurefile-node-9qmvm               30m (1%)      0 (0%)      60Mi (1%)        600Mi (13%)    54m
  kube-system                 konnectivity-agent-6fcddb8b5b-wxbdd    20m (1%)      1 (52%)     20Mi (0%)        1Gi (22%)      26m
  kube-system                 kube-proxy-nm7sn                       100m (5%)     0 (0%)      0 (0%)           0 (0%)         54m
  practica-k8s                task-pv-pod                            0 (0%)        0 (0%)      0 (0%)           0 (0%)         45m
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                330m (17%)  1500m (78%)
  memory             240Mi (5%)  2786Mi (61%)
  ephemeral-storage  0 (0%)      0 (0%)
  hugepages-1Gi      0 (0%)      0 (0%)
  hugepages-2Mi      0 (0%)      0 (0%)
Events:
  Type     Reason                   Age                From             Message
  ----     ------                   ----               ----             -------
  Normal   Starting                 53m                kube-proxy       
  Normal   Starting                 54m                kubelet          Starting kubelet.
  Warning  InvalidDiskCapacity      54m                kubelet          invalid capacity 0 on image filesystem
  Normal   NodeHasSufficientMemory  54m (x2 over 54m)  kubelet          Node aks-default-41951121-vmss000000 status is now: NodeHasSufficientMemory
  Normal   NodeHasNoDiskPressure    54m (x2 over 54m)  kubelet          Node aks-default-41951121-vmss000000 status is now: NodeHasNoDiskPressure
  Normal   NodeHasSufficientPID     54m (x2 over 54m)  kubelet          Node aks-default-41951121-vmss000000 status is now: NodeHasSufficientPID
  Normal   NodeAllocatableEnforced  54m                kubelet          Updated Node Allocatable limit across pods
  Normal   RegisteredNode           53m                node-controller  Node aks-default-41951121-vmss000000 event: Registered Node aks-default-41951121-vmss000000 in Controller
  Normal   NodeReady                53m                kubelet          Node aks-default-41951121-vmss000000 status is now: NodeReady
miguel@willy:~$ kubectl describe node aks-default-41951121-vmss000001
Name:               aks-default-41951121-vmss000001
Roles:              agent
Labels:             agentpool=default
                    beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/instance-type=Standard_D2_v2
                    beta.kubernetes.io/os=linux
                    failure-domain.beta.kubernetes.io/region=uksouth
                    failure-domain.beta.kubernetes.io/zone=0
                    kubernetes.azure.com/agentpool=default
                    kubernetes.azure.com/cluster=MC_practica2rg_aks01_uksouth
                    kubernetes.azure.com/consolidated-additional-properties=d0438adf-26ef-11ee-a7f7-564b98600cf9
                    kubernetes.azure.com/kubelet-identity-client-id=98030437-8015-4c74-bf64-fd493fd7d66e
                    kubernetes.azure.com/mode=system
                    kubernetes.azure.com/node-image-version=AKSUbuntu-2204containerd-202307.04.0
                    kubernetes.azure.com/nodepool-type=VirtualMachineScaleSets
                    kubernetes.azure.com/os-sku=Ubuntu
                    kubernetes.azure.com/role=agent
                    kubernetes.azure.com/storageprofile=managed
                    kubernetes.azure.com/storagetier=Standard_LRS
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=aks-default-41951121-vmss000001
                    kubernetes.io/os=linux
                    kubernetes.io/role=agent
                    node-role.kubernetes.io/agent=
                    node.kubernetes.io/instance-type=Standard_D2_v2
                    storageprofile=managed
                    storagetier=Standard_LRS
                    topology.disk.csi.azure.com/zone=
                    topology.kubernetes.io/region=uksouth
                    topology.kubernetes.io/zone=0
Annotations:        csi.volume.kubernetes.io/nodeid:
                      {"disk.csi.azure.com":"aks-default-41951121-vmss000001","file.csi.azure.com":"aks-default-41951121-vmss000001"}
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Thu, 20 Jul 2023 13:25:45 +0200
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  aks-default-41951121-vmss000001
  AcquireTime:     <unset>
  RenewTime:       Thu, 20 Jul 2023 14:20:12 +0200
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Thu, 20 Jul 2023 13:26:45 +0200   Thu, 20 Jul 2023 13:26:45 +0200   RouteCreated                 RouteController created a route
  MemoryPressure       False   Thu, 20 Jul 2023 14:18:20 +0200   Thu, 20 Jul 2023 13:25:45 +0200   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure         False   Thu, 20 Jul 2023 14:18:20 +0200   Thu, 20 Jul 2023 13:25:45 +0200   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure          False   Thu, 20 Jul 2023 14:18:20 +0200   Thu, 20 Jul 2023 13:25:45 +0200   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready                True    Thu, 20 Jul 2023 14:18:20 +0200   Thu, 20 Jul 2023 13:25:55 +0200   KubeletReady                 kubelet is posting ready status. AppArmor enabled
Addresses:
  InternalIP:  10.224.0.5
  Hostname:    aks-default-41951121-vmss000001
Capacity:
  cpu:                2
  ephemeral-storage:  129886128Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             7098320Ki
  pods:               110
Allocatable:
  cpu:                1900m
  ephemeral-storage:  119703055367
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             4653008Ki
  pods:               110
System Info:
  Machine ID:                 39cbf3575ebd45d08b37a940e20b4066
  System UUID:                4a1a9e08-87b1-2940-900b-713015f78671
  Boot ID:                    13065996-cc47-4598-bbba-143e435b0224
  Kernel Version:             5.15.0-1041-azure
  OS Image:                   Ubuntu 22.04.2 LTS
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://1.7.1+azure-1
  Kubelet Version:            v1.25.6
  Kube-Proxy Version:         v1.25.6
PodCIDR:                      10.244.0.0/24
PodCIDRs:                     10.244.0.0/24
ProviderID:                   azure:///subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/mc_practica2rg_aks01_uksouth/providers/Microsoft.Compute/virtualMachineScaleSets/aks-default-41951121-vmss/virtualMachines/1
Non-terminated Pods:          (11 in total)
  Namespace                   Name                                   CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                   ------------  ----------  ---------------  -------------  ---
  kube-system                 azure-ip-masq-agent-5dsll              100m (5%)     500m (26%)  50Mi (1%)        250Mi (5%)     54m
  kube-system                 cloud-node-manager-6lhkb               50m (2%)      0 (0%)      50Mi (1%)        512Mi (11%)    54m
  kube-system                 coredns-autoscaler-69b7556b86-w8d28    20m (1%)      200m (10%)  10Mi (0%)        500Mi (11%)    54m
  kube-system                 coredns-fb6b9d95f-jzcsn                100m (5%)     3 (157%)    70Mi (1%)        500Mi (11%)    53m
  kube-system                 coredns-fb6b9d95f-xk4qr                100m (5%)     3 (157%)    70Mi (1%)        500Mi (11%)    54m
  kube-system                 csi-azuredisk-node-577st               30m (1%)      0 (0%)      60Mi (1%)        400Mi (8%)     54m
  kube-system                 csi-azurefile-node-xnt2z               30m (1%)      0 (0%)      60Mi (1%)        600Mi (13%)    54m
  kube-system                 konnectivity-agent-6fcddb8b5b-bwktq    20m (1%)      1 (52%)     20Mi (0%)        1Gi (22%)      26m
  kube-system                 kube-proxy-9whpk                       100m (5%)     0 (0%)      0 (0%)           0 (0%)         54m
  kube-system                 metrics-server-845978bcd7-gj4fm        50m (2%)      145m (7%)   89Mi (1%)        359Mi (7%)     53m
  kube-system                 metrics-server-845978bcd7-tpgpg        50m (2%)      145m (7%)   89Mi (1%)        359Mi (7%)     53m
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests     Limits
  --------           --------     ------
  cpu                650m (34%)   7990m (420%)
  memory             568Mi (12%)  5004Mi (110%)
  ephemeral-storage  0 (0%)       0 (0%)
  hugepages-1Gi      0 (0%)       0 (0%)
  hugepages-2Mi      0 (0%)       0 (0%)
Events:
  Type     Reason                   Age                From             Message
  ----     ------                   ----               ----             -------
  Normal   Starting                 54m                kube-proxy       
  Normal   RegisteredNode           54m                node-controller  Node aks-default-41951121-vmss000001 event: Registered Node aks-default-41951121-vmss000001 in Controller
  Normal   Starting                 54m                kubelet          Starting kubelet.
  Warning  InvalidDiskCapacity      54m                kubelet          invalid capacity 0 on image filesystem
  Normal   NodeHasSufficientMemory  54m (x2 over 54m)  kubelet          Node aks-default-41951121-vmss000001 status is now: NodeHasSufficientMemory
  Normal   NodeHasNoDiskPressure    54m (x2 over 54m)  kubelet          Node aks-default-41951121-vmss000001 status is now: NodeHasNoDiskPressure
  Normal   NodeHasSufficientPID     54m (x2 over 54m)  kubelet          Node aks-default-41951121-vmss000001 status is now: NodeHasSufficientPID
  Normal   NodeAllocatableEnforced  54m                kubelet          Updated Node Allocatable limit across pods
  Normal   NodeReady                54m                kubelet          Node aks-default-41951121-vmss000001 status is now: NodeReady
miguel@willy:~$ 


