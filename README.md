# Practica_2
version 0.0.1
# terraform
1 creo infraestructura con terraform
    grupo de recursos (rg)
    container registry (acr)
    cluster de kubernetes (aks)
    virtual network
    subnet
    network interface
    public ip
    virtual machine (vm)
    admin de ssh
    plan
    source image reference
    grupo de network security (ngs)
    azurerm_subnet_network_security_group_association (ngs-link)

# ansible
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



# miguel@willy:~$ kubectl get pvc -n practica-k8s
NAME                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
pvc-azurefile-csi   Bound    pvc-376a78fc-6f6b-4eb5-9704-fc40e9ac6b9a   1Gi        RWO            azurefile-csi   17m
# miguel@willy:~$ kubectl get pv -n practica-k8s
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                            STORAGECLASS    REASON   AGE
pvc-376a78fc-6f6b-4eb5-9704-fc40e9ac6b9a   1Gi        RWO            Delete           Bound    practica-k8s/pvc-azurefile-csi   azurefile-csi            17m
# miguel@willy:~$ kubectl get services -n practica-k8s
NAME                 TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)        AGE
persistent-storage   LoadBalancer   10.0.187.49   20.108.204.192   81:31671/TCP   17m
# miguel@willy:~$ kubectl get ns
NAME              STATUS   AGE
default           Active   31m
kube-node-lease   Active   32m
kube-public       Active   32m
kube-system       Active   32m
practica-k8s      Active   27m
# miguel@willy:~$ kubectl get pods -n practica-k8s
NAME                                  READY   STATUS    RESTARTS   AGE
persistent-storage-67ff9658dc-qj4hd   0/1     Pending   0          17m
# miguel@willy:~$ kubectl get deployment -n practica-k8s
NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
persistent-storage   0/1     1            0           18m
# miguel@willy:~$ kubectl describe node aks-node1-33040483-vmss000000
Name:               aks-node1-33040483-vmss000000
Roles:              agent
Labels:             agentpool=node1
                    beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/instance-type=Standard_D2_v2
                    beta.kubernetes.io/os=linux
                    failure-domain.beta.kubernetes.io/region=uksouth
                    failure-domain.beta.kubernetes.io/zone=0
                    kubernetes.azure.com/agentpool=node1
                    kubernetes.azure.com/cluster=MC_practica2rg_aks01_uksouth
                    kubernetes.azure.com/consolidated-additional-properties=8de3c38d-25b0-11ee-af9c-66401807ca23
                    kubernetes.azure.com/kubelet-identity-client-id=746d548b-078f-44d1-bfe0-0527e1585fda
                    kubernetes.azure.com/mode=system
                    kubernetes.azure.com/node-image-version=AKSUbuntu-2204containerd-202307.04.0
                    kubernetes.azure.com/nodepool-type=VirtualMachineScaleSets
                    kubernetes.azure.com/os-sku=Ubuntu
                    kubernetes.azure.com/role=agent
                    kubernetes.azure.com/storageprofile=managed
                    kubernetes.azure.com/storagetier=Standard_LRS
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=aks-node1-33040483-vmss000000
                    kubernetes.io/os=linux
                    kubernetes.io/role=agent
                    node-role.kubernetes.io/agent=
                    node.kubernetes.io/instance-type=Standard_D2_v2
                    storageprofile=managed
                    storagetier=Standard_LRS
                    topology.disk.csi.azure.com/zone=
                    topology.kubernetes.io/region=uksouth
                    topology.kubernetes.io/zone=0
Annotations:        csi.volume.kubernetes.io/nodeid: {"disk.csi.azure.com":"aks-node1-33040483-vmss000000","file.csi.azure.com":"aks-node1-33040483-vmss000000"}
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Tue, 18 Jul 2023 23:20:28 +0200
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  aks-node1-33040483-vmss000000
  AcquireTime:     <unset>
  RenewTime:       Tue, 18 Jul 2023 23:31:10 +0200
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Tue, 18 Jul 2023 23:22:09 +0200   Tue, 18 Jul 2023 23:22:09 +0200   RouteCreated                 RouteController created a route
  MemoryPressure       False   Tue, 18 Jul 2023 23:31:01 +0200   Tue, 18 Jul 2023 23:20:28 +0200   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure         False   Tue, 18 Jul 2023 23:31:01 +0200   Tue, 18 Jul 2023 23:20:28 +0200   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure          False   Tue, 18 Jul 2023 23:31:01 +0200   Tue, 18 Jul 2023 23:20:28 +0200   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready                True    Tue, 18 Jul 2023 23:31:01 +0200   Tue, 18 Jul 2023 23:20:39 +0200   KubeletReady                 kubelet is posting ready status. AppArmor enabled
Addresses:
  InternalIP:  10.224.0.5
  Hostname:    aks-node1-33040483-vmss000000
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
  Machine ID:                 e5e0eb6c9cd24947a42c79493b68bc91
  System UUID:                d7327259-4e6c-4b4d-aeb2-6c9118896ac1
  Boot ID:                    615b507b-1cfc-4366-afe3-2df974681047
  Kernel Version:             5.15.0-1041-azure
  OS Image:                   Ubuntu 22.04.2 LTS
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://1.7.1+azure-1
  Kubelet Version:            v1.25.6
  Kube-Proxy Version:         v1.25.6
PodCIDR:                      10.244.1.0/24
PodCIDRs:                     10.244.1.0/24
ProviderID:                   azure:///subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/mc_practica2rg_aks01_uksouth/providers/Microsoft.Compute/virtualMachineScaleSets/aks-node1-33040483-vmss/virtualMachines/0
Non-terminated Pods:          (6 in total)
  Namespace                   Name                                   CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                   ------------  ----------  ---------------  -------------  ---
  kube-system                 azure-ip-masq-agent-8tq2h              100m (5%)     500m (26%)  50Mi (1%)        250Mi (5%)     10m
  kube-system                 cloud-node-manager-ztkwd               50m (2%)      0 (0%)      50Mi (1%)        512Mi (11%)    10m
  kube-system                 csi-azuredisk-node-2xkqf               30m (1%)      0 (0%)      60Mi (1%)        400Mi (8%)     10m
  kube-system                 csi-azurefile-node-54k54               30m (1%)      0 (0%)      60Mi (1%)        600Mi (13%)    10m
  kube-system                 konnectivity-agent-7d787d94ff-bwt8r    20m (1%)      1 (52%)     20Mi (0%)        1Gi (22%)      25s
  kube-system                 kube-proxy-j8gls                       100m (5%)     0 (0%)      0 (0%)           0 (0%)         10m
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
  Type    Reason                   Age                From             Message
  ----    ------                   ----               ----             -------
  Normal  Starting                 10m                kube-proxy       
  Normal  NodeHasSufficientMemory  10m (x8 over 10m)  kubelet          Node aks-node1-33040483-vmss000000 status is now: NodeHasSufficientMemory
  Normal  RegisteredNode           10m                node-controller  Node aks-node1-33040483-vmss000000 event: Registered Node aks-node1-33040483-vmss000000 in Controller
# miguel@willy:~$ kubectl describe node aks-node1-33040483-vmss000001
Name:               aks-node1-33040483-vmss000001
Roles:              agent
Labels:             agentpool=node1
                    beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/instance-type=Standard_D2_v2
                    beta.kubernetes.io/os=linux
                    failure-domain.beta.kubernetes.io/region=uksouth
                    failure-domain.beta.kubernetes.io/zone=0
                    kubernetes.azure.com/agentpool=node1
                    kubernetes.azure.com/cluster=MC_practica2rg_aks01_uksouth
                    kubernetes.azure.com/consolidated-additional-properties=8de3c38d-25b0-11ee-af9c-66401807ca23
                    kubernetes.azure.com/kubelet-identity-client-id=746d548b-078f-44d1-bfe0-0527e1585fda
                    kubernetes.azure.com/mode=system
                    kubernetes.azure.com/node-image-version=AKSUbuntu-2204containerd-202307.04.0
                    kubernetes.azure.com/nodepool-type=VirtualMachineScaleSets
                    kubernetes.azure.com/os-sku=Ubuntu
                    kubernetes.azure.com/role=agent
                    kubernetes.azure.com/storageprofile=managed
                    kubernetes.azure.com/storagetier=Standard_LRS
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=aks-node1-33040483-vmss000001
                    kubernetes.io/os=linux
                    kubernetes.io/role=agent
                    node-role.kubernetes.io/agent=
                    node.kubernetes.io/instance-type=Standard_D2_v2
                    storageprofile=managed
                    storagetier=Standard_LRS
                    topology.disk.csi.azure.com/zone=
                    topology.kubernetes.io/region=uksouth
                    topology.kubernetes.io/zone=0
Annotations:        csi.volume.kubernetes.io/nodeid: {"disk.csi.azure.com":"aks-node1-33040483-vmss000001","file.csi.azure.com":"aks-node1-33040483-vmss000001"}
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Tue, 18 Jul 2023 23:20:06 +0200
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  aks-node1-33040483-vmss000001
  AcquireTime:     <unset>
  RenewTime:       Tue, 18 Jul 2023 23:31:41 +0200
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Tue, 18 Jul 2023 23:21:09 +0200   Tue, 18 Jul 2023 23:21:09 +0200   RouteCreated                 RouteController created a route
  MemoryPressure       False   Tue, 18 Jul 2023 23:26:43 +0200   Tue, 18 Jul 2023 23:20:06 +0200   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure         False   Tue, 18 Jul 2023 23:26:43 +0200   Tue, 18 Jul 2023 23:20:06 +0200   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure          False   Tue, 18 Jul 2023 23:26:43 +0200   Tue, 18 Jul 2023 23:20:06 +0200   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready                True    Tue, 18 Jul 2023 23:26:43 +0200   Tue, 18 Jul 2023 23:20:16 +0200   KubeletReady                 kubelet is posting ready status. AppArmor enabled
Addresses:
  InternalIP:  10.224.0.4
  Hostname:    aks-node1-33040483-vmss000001
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
  Machine ID:                 1ff42d7f92b542d6b54a18602f0ab256
  System UUID:                c123a464-f576-f541-8318-c5c249d6bff6
  Boot ID:                    13ad2055-4487-4c23-aa74-63a23b70e6c3
  Kernel Version:             5.15.0-1041-azure
  OS Image:                   Ubuntu 22.04.2 LTS
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://1.7.1+azure-1
  Kubelet Version:            v1.25.6
  Kube-Proxy Version:         v1.25.6
PodCIDR:                      10.244.0.0/24
PodCIDRs:                     10.244.0.0/24
ProviderID:                   azure:///subscriptions/4cec99f2-dcb1-40e5-b292-66072a2186b8/resourceGroups/mc_practica2rg_aks01_uksouth/providers/Microsoft.Compute/virtualMachineScaleSets/aks-node1-33040483-vmss/virtualMachines/1
Non-terminated Pods:          (11 in total)
  Namespace                   Name                                   CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                   ------------  ----------  ---------------  -------------  ---
  kube-system                 azure-ip-masq-agent-skr2v              100m (5%)     500m (26%)  50Mi (1%)        250Mi (5%)     11m
  kube-system                 cloud-node-manager-b5nh8               50m (2%)      0 (0%)      50Mi (1%)        512Mi (11%)    11m
  kube-system                 coredns-autoscaler-69b7556b86-4wcbc    20m (1%)      200m (10%)  10Mi (0%)        500Mi (11%)    11m
  kube-system                 coredns-fb6b9d95f-kh2xv                100m (5%)     3 (157%)    70Mi (1%)        500Mi (11%)    10m
  kube-system                 coredns-fb6b9d95f-z2jvc                100m (5%)     3 (157%)    70Mi (1%)        500Mi (11%)    11m
  kube-system                 csi-azuredisk-node-rgl7j               30m (1%)      0 (0%)      60Mi (1%)        400Mi (8%)     11m
  kube-system                 csi-azurefile-node-wqzxv               30m (1%)      0 (0%)      60Mi (1%)        600Mi (13%)    11m
  kube-system                 konnectivity-agent-7d787d94ff-v48lz    20m (1%)      1 (52%)     20Mi (0%)        1Gi (22%)      57s
  kube-system                 kube-proxy-9w4wf                       100m (5%)     0 (0%)      0 (0%)           0 (0%)         11m
  kube-system                 metrics-server-845978bcd7-qgj86        50m (2%)      145m (7%)   89Mi (1%)        359Mi (7%)     10m
  kube-system                 metrics-server-845978bcd7-wk6ps        50m (2%)      145m (7%)   89Mi (1%)        359Mi (7%)     10m
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
  Normal   Starting                 11m                kube-proxy       
  Normal   Starting                 11m                kubelet          Starting kubelet.
  Warning  InvalidDiskCapacity      11m                kubelet          invalid capacity 0 on image filesystem
  Normal   NodeHasSufficientMemory  11m (x2 over 11m)  kubelet          Node aks-node1-33040483-vmss000001 status is now: NodeHasSufficientMemory
  Normal   NodeHasNoDiskPressure    11m (x2 over 11m)  kubelet          Node aks-node1-33040483-vmss000001 status is now: NodeHasNoDiskPressure
  Normal   NodeHasSufficientPID     11m (x2 over 11m)  kubelet          Node aks-node1-33040483-vmss000001 status is now: NodeHasSufficientPID
  Normal   NodeAllocatableEnforced  11m                kubelet          Updated Node Allocatable limit across pods
  Normal   RegisteredNode           11m                node-controller  Node aks-node1-33040483-vmss000001 event: Registered Node aks-node1-33040483-vmss000001 in Controller
  Normal   NodeReady                11m                kubelet          Node aks-node1-33040483-vmss000001 status is now: NodeReady
miguel@willy:~$ kubectl get deployment,pods,services -n practica-k8s
NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/persistent-storage   0/1     1            0           21m

NAME                                      READY   STATUS    RESTARTS   AGE
pod/persistent-storage-67bd677444-jjkn5   0/1     Pending   0          21m

NAME                         TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)        AGE
service/persistent-storage   LoadBalancer   10.0.137.122   51.105.21.76   80:31888/TCP   21m

