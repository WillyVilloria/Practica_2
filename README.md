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
        creo clave privada para el certificado
        creo la peticion de firma del certificado
        creo certificado utilizando la clave privada y la peticion firmada
        defino la pagina principal del servidor
        definir la configuración del servidor web
        establecer la configuración de autenticación básica
        Definir el fichero para la creación de la imagen del contenedor
        Generar la imagen del contenedor
        Etiquetar la imagen del contenedor
        
        # Subir la imagen del contenedor al registry
            Autenticarse en el Registry
            Subir la imagen del contenedor al Registry
            Crear el contenedor del servicio Web a partir de la imagen creada en el paso anterior
            Generar los ficheros para gestionar el contenedor a través de systemd
            Copiar los ficheros generados en el paso previo al directorio de systemd
            Recargar la configuración de systemd
            Iniciar la aplicación Web desde systemd
            Verificar la conectividad al servidor Web

3 con ansible tengo que preparar la imagen en kubernetes para albergar la app.
