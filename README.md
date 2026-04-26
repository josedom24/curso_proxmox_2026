# Curso Proxmox VE (2026)

Cursos Proxmox VE, Entornos de Virtualización para Centros Educativos. 

## Contenidos

### Sesión1: Introducción a la virtualización con Proxmox VE

* ¿Qué nos ofrece Proxmox VE?
    * Introducción a la virtualización
    * Qué soluciones de virtualización ofrece Proxmox VE
* Diferencias con otros sistemas de virtualización
    * Diferencias de Proxmox VE us OpenStack
* Evolución de sistemas de virtualización en el IES Gonzalo Nazareno
    * Desde 2011 utilizando OpenStack gracias a un proyecto de innovación educativa.
    * En 2022 se introduce el uso de Proxmox VE.
    * Estas tecnologías han producido cambios en las metodologías educativas.
* Características e infraestructura del centro
    * Descripción general del entorno: número de aulas, alumnos, módulos impartidos.
    * Diagrama o esquema de la infraestructura virtualizada.
    * Versión de Proxmox VE en uso y política de actualizaciones.
    * Servidores físicos: modelos, CPU, RAM, almacenamiento.
    * Red interna del CPD: switches, VLANs, velocidades.
    * Almacenamiento: tipo de discos, pools Ceph o SAN/NAS, capacidad total.
    * Cómo acceden los alumnos desde las aulas y desde casa.
    * Solución de acceso remoto: Guacamole, VPN, noVNC u otras.
    * Seguridad perimetral: firewall, proxy inverso, certificados.

### Sesión 2: Uso básico de Proxmox VE

* Introducción al entorno de trabajo de Proxmox VE
    * Almacenamiento y redes disponibles
    * Conceptos necesarios: Plantillas, Clonación, Pool de recursos.
* Introducción a la gestión de máquinas virtuales 
    * Creación de MV desde imágenes ISO
    * Dispositivos paravirtualizados e instalación de máquinas Windows.
    * Instalación de Qemu-guest-agent en las máquinas virtuales
    * Acceso a las máquinas virtuales
* Introducción a la gestión de contenedores
    * Plantillas de contenedores
    * Creación de contenedores

### Sesión 3: Almacenamiento y redes en Proxmox VE

* Gestión de almacenamiento en Proxmox VE
* Añadir almacenamiento a las máquinas virtuales
* Introducción a la gestión de redes con Proxmox VE
* Clonación de máquinas virtuales
* Convirtiendo máquinas virtuales en plantillas
* Snapshots de máquinas virtuales
* Copias de seguridad de máquinas virtuales

### Sesión 4: Configuración especifica de Proxmox VE en el IES Gonzalo Nazareno

* Configuración específica en nuestro centro
    * Queremos conseguir que los propios alumnos manejen su espacio en Proxmox VE.
    * Introducción a usuarios, roles y permisos.
    * Queremos que los usuarios creen de forma rápida nuevas MV. Para ello podrán clonar plantillas que ya tenemos predefinidas.
* Configuración de los usuarios (servidor LDAP) y permisos necesarios.
* Configuración de las imágenes preconfiguradas para su clonación.
* Configuración de máquinas virtuales usando cloud-init
* Creación de imágenes con cloud-init
* Configuración de acceso mediante proxy inverso
* Scripts de administración: instrucciones de línea de comandos. 
* Próximos pasos:
    * Almacenamiento remoto SAN/NAS
    * Clúster de alta disponibilidad