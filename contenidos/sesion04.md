---
marp: true
theme: profesional
title: "Proxmox VE"
paginate: true
header: 'Proxmox VE · Sesión 4 — Configuración específica de Proxmox VE en el IES Gonzalo Nazareno'
---

<!-- _class: portada -->
<!-- _paginate: false -->



# Virtualización con **Proxmox VE**

## Sesión 4 · Configuración específica de Proxmox VE en el IES Gonzalo Nazareno

<div style="margin-top:2rem; display:flex; flex-direction:column; gap:0.5rem; justify-content:center; font-size:0.85rem; color:white">
  <span>📧 José Domingo Muñoz</span>
  <span>🏫 IES Gonzalo Nazareno · Dos Hermanas</span>
  <span>🌐 <a href="https://josedom24.github.io/curso_proxmox_2026" style="color:white">josedom24.github.io/curso_proxmox_2026</a></span>
  <span>💻 <a href="https://github.com/josedom24/curso_proxmox_2026" style="color:white">github.com/josedom24/curso_proxmox_2026</a></span>
</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->


<p class="numero">01</p>

# Configuración específica en nuestro centro

## Objetivos y principios

---

## Conceptos clave (I)

<div class="cols-2" style="margin-top:1.5rem">

<div class="card card-blue">

### Pools de recursos

Agrupación lógica de:
- **Máquinas virtuales (MV)**
- **Contenedores (LXC)**
- **Almacenamiento**

Para facilitar su gestión y asignación de cuotas.

Cada usuario o departamento puede tener su propio pool.

Permite **organizar y limitar** los recursos disponibles.

</div>

<div class="card card-green">

### Usuarios y Grupos

**Usuarios**: cuentas individuales que acceden a Proxmox (integrados con LDAP del centro).

**Grupos**: agrupaciones de usuarios para facilitar la asignación de permisos comunes.

Simplifica la **administración de permisos a escala**.

</div>

</div>

---

## Conceptos clave (II)

<div class="cols-2" style="margin-top:1.5rem">

<div class="card card-purple">

### Rol

Conjunto predefinido de **permisos** asociados a una función específica.

Ejemplos: *Administrator*, *PVEAdmin*, *PVEUser*, *PVEVMUser*

Cada rol define un **conjunto de capacidades**.

</div>

<div class="card card-yellow">

### Permisos

Reglas que definen **qué acciones puede hacer** cada usuario sobre cada recurso.

Se asignan combinando: usuario/grupo + rol + recurso (nodo, VM, pool, etc.)

Control **granular y flexible**.

</div>

</div>

---

## ¿Qué queríamos conseguir? (I)

<div class="cols-2" style="margin-top:1.5rem">

<div class="card card-blue">

### Control de recursos

Usuarios que **controlen sus propios recursos** en Proxmox:
- Máquinas virtuales (MV)
- Contenedores LXC
- Almacenamiento asignado

Cada usuario gestiona su espacio de forma **independiente y segura**.

</div>

<div class="card card-green">

### Limitaciones de seguridad

Las **redes no pueden ser controladas** por usuarios — es una restricción de seguridad.

Solo el administrador configura la topología de red, bridges y VLANs.

**Garantiza la integridad** de la infraestructura de red.

</div>

</div>

---

## ¿Qué queríamos conseguir? (II)

<div style="margin-top:2rem">

<div class="card card-purple">

### Creación rápida de máquinas

Aunque los usuarios pueden crear MV desde una ISO, queremos que lo hagan de forma **rápida y ágil**.

**Solución**: **clonar plantillas predefinidas** que ya tenemos preparadas.

**Ventajas:**
- Ahorra tiempo de instalación
- Garantiza configuraciones **consistentes**
- Todos los alumnos parten del mismo estado
- Reduce errores de instalación

</div>

</div>

---

## Roles creados en nuestro Proxmox VE (I)

En el IES hemos definido **cuatro roles** para separar responsabilidades y permitir que cada usuario tenga solo los permisos necesarios:

<div class="cols-2" style="margin-top:1.5rem">

<div class="card card-blue">

### `iesgn`

**Rol de usuario estándar**

Usuario completo que puede **crear, modificar y gestionar** sus propias máquinas virtuales con amplia autonomía.

Sin acceso de administrador del clúster.

</div>

<div class="card card-green">

### `iesgn-red`

**Rol de redes**

Acceso especializado para la **administración de redes SDN**.

Crear y gestionar redes virtuales sin tocar VMs ni almacenamiento.

</div>

</div>

---

## Roles creados en nuestro Proxmox VE (II)

<div class="cols-2" style="margin-top:1.5rem">

<div class="card card-purple">

### `iesgn-template-clone`

**Rol para clonar plantillas**

Usuario que **solo puede crear VMs** clonando plantillas ya existentes.

No puede modificar ni crear plantillas nuevas.

</div>

<div class="card card-yellow">

### `iesgn-template-create`

**Rol para crear plantillas**

Usuario autorizado a **crear nuevas máquinas** que se convertirán en plantillas.

Complemento del rol anterior en el flujo de trabajo de plantillas.

</div>

</div>

---

## Permisos detallados por rol

<table style="width:100%; font-size:0.85rem; margin-top:0.5rem">
<thead>
  <tr style="background:#f0f0f0">
    <th style="width:35%; text-align:left; padding:0.5rem">Rol</th>
    <th style="width:65%; text-align:left; padding:0.5rem">Permisos</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd"><strong>iesgn</strong></td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd; font-size:0.8rem"><code>Datastore.AllocateSpace</code> <code>Datastore.Audit</code> <code>Permissions.Modify</code> <code>Pool.Audit</code> <code>SDN.Use</code> <code>Sys.Audit</code> <code>Sys.Console</code> <code>Sys.Modify</code> <code>Sys.Syslog</code> <code>VM.Allocate</code> <code>VM.Audit</code> <code>VM.Console</code> <code>VM.PowerMgmt</code> <code>VM.Backup</code> <code>VM.Clone</code> <code>VM.Migrate</code> <code>VM.Snapshot</code> <code>VM.Snapshot.Rollback</code> <code>VM.Config.*</code> <code>VM.GuestAgent.*</code></td>
  </tr>
  <tr>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd"><strong>iesgn-red</strong></td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd; font-size:0.8rem"><code>SDN.Allocate</code> <code>SDN.Audit</code> <code>SDN.Use</code> <code>Sys.Modify</code></td>
  </tr>
  <tr>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd"><strong>iesgn-template-clone</strong></td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd; font-size:0.8rem"><code>Pool.Audit</code> <code>VM.Audit</code> <code>VM.Clone</code></td>
  </tr>
  <tr>
    <td style="padding:0.4rem"><strong>iesgn-template-create</strong></td>
    <td style="padding:0.4rem; font-size:0.8rem"><code>Pool.Allocate</code> <code>VM.Allocate</code></td>
  </tr>
</tbody>
</table>

<div style="text-align:center; margin-top:1rem">

![height:140px](img/rol1.png)

</div>

---

## ¿Cómo podemos conseguirlo? (I)

<div class="card card-blue" style="margin-top:1.2rem">

#### 1. Grupos de usuarios

Los usuarios se agrupan por **curso o categoría**:
- `@asir1-iesgn` — alumnos de 1º ASIR
- `@smr2-iesgn` — alumnos de 2º SMR
- `@profesores-iesgn` — profesores

Facilita la **asignación masiva de permisos**.

</div>

---

## ¿Cómo podemos conseguirlo? (II)

<div class="card card-green" style="margin-top:1.2rem">

#### 2. Pools de recursos

- **Pool "Proyecto de usuario"**
  - Asignado a cada usuario individual o grupo
  - Cada usuario crea sus propios recursos en su pool
  - Proporciona **aislamiento y seguridad**

- **Pool "Imágenes"**
  - Repositorio centralizado de plantillas
  - Los usuarios pueden **clonar plantillas** de aquí
  - Solo profesores pueden crear/modificar plantillas

</div>

---

## Asignación de permisos

### Cuatro ámbitos del control de acceso

1. **Administración global** → solo `admin@pve` en la raíz.

2. **Plantillas** → profesores las producen, todos las consumen.

3. **Proyectos de alumnos** → cada alumno (o grupo reducido) gestiona únicamente su propio pool, sin ver ni tocar los de los demás.

4. **Red SDN** → todos los colectivos pueden trabajar con redes virtuales dentro de la zona `localnetwork`, pero sin afectar la red física del clúster.

### Principio de diseño

**Mínimo privilegio**: cada usuario recibe solo los permisos necesarios para su función, con **herencia automática** hacia los recursos dentro de su ámbito.

---

## Tabla de ACLs — Ejemplo práctico

<div style="text-align:center; margin-top:3rem">

![height:380px](img/rol2.png)

</div>

---

## Posibles mejoras

<div class="cols-2" style="margin-top:1.5rem">

<div class="card card-blue">

### 1. Rol `iesgn-profesor`

Crear un rol específico para profesores que incluya `Pool.Allocate`, permitiendo:
- Crear plantillas en su proyecto personal (sin exposición al alumnado)
- Reasignarlas a `/pool/Imagenes` cuando estén listas
- Actualmente el profesor puede hacer plantillas directamente en el `/pool/Imagenes`

</div>

<div class="card card-green">

### 2. Acceso supervisado a pools del alumnado

Otorgar al grupo `profesores-iesgn` acceso de auditoría o intervención sobre los pools del alumnado:
- Supervisar y evaluar el trabajo en curso
- Diagnosticar incidencias técnicas
- Intervenir en situaciones bloqueantes sin credenciales admin

</div>

</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">02</p>

# DEMO 1: Clonación de MV de un usuario

## Perfil alumno

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">02</p>

# DEMO 2: Configuración de máquinas virtuales usando cloud-init

## Automatización de la configuración inicial

---

## Concepto de cloud-init

<div style="margin-top:1.5rem">

<div class="card card-blue">

### ¿Qué es cloud-init?

**cloud-init** es un estándar de inicialización que permite **configurar máquinas virtuales automáticamente** en el primer arranque sin intervención manual.

### ¿Por qué es necesario?

- **Ahorra tiempo**: no hay que entrar manualmente en cada máquina
- **Consistencia**: todas las máquinas se configuran igual
- **Escalabilidad**: permite provisionar cientos de máquinas rápidamente
- **Flexibilidad**: cada máquina puede tener configuración única sin crear plantillas distintas

</div>

</div>

---

## Configuración con cloud-init

<div class="cols-2" style="margin-top:1rem">

<div class="card card-green">

### Parámetros configurables

Los templates con cloud-init permiten configurar:

- **Hostname** de la máquina
- **Usuario y contraseña** de acceso
- **Clave pública SSH** para acceso remoto
- **Configuración de red** (IP, DNS, rutas)
- **DNS** y otros parámetros de red

</div>

<div class="card card-purple">

### Mecanismo de entrega

cloud-init obtiene la configuración desde un:

- **Dispositivo CDROM virtual** en el hardware de la máquina
- Contiene un archivo de configuración YAML
- Se ejecuta **solo en el primer arranque**
- Luego se desactiva automáticamente

</div>

</div>

---

## Templates con cloud-init en nuestro centro

<div class="card card-yellow" style="margin-top:1.5rem">

### Máquinas virtuales base

Los **templates del pool "Imágenes"** son máquinas virtuales con **cloud-init ya instalado**, listos para ser clonados.

### Ventajas de nuestro enfoque

- Los usuarios **clonan una plantilla** existente
- La máquina nueva se **configura automáticamente** en el primer arranque
- Cada usuario puede personalizar:
  - Nombre de máquina
  - Credenciales de acceso
  - Configuración de red
  - Claves SSH para acceso remoto

**Resultado**: creación rápida, consistente y personalizada de máquinas virtuales

</div>

---

## Soporte para otros sistemas operativos

<div class="cols-2" style="margin-top:1rem">

<div class="card card-blue">

### Linux (cloud-init)

- Todas las distribuciones modernas incluyen cloud-init
- Compatible con Debian, Ubuntu, CentOS, etc.
- Recurso: [Configuración automática de una máquina virtual de Proxmox con cloud-init](https://www.josedomingo.org/pledin/2022/10/proxmox-cloud-init/)

</div>

<div class="card card-orange">

### Windows (cloudbase-init o Sysprep)

- **cloudbase-init**: equivalente a cloud-init para Windows
- **Sysprep**: herramienta de Microsoft para generalizar la instalación. Cuando clonamos a partir del tamplate comienza la última fase de configuración (**hay que asigna nueva contraseña**).


</div>

</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">03</p>

# Scripts de administración

## Instrucciones de línea de comandos para automatización

---

## La API de Proxmox VE

<div class="card card-blue" style="margin-top:1.5rem">

### Arquitectura general

Proxmox expone **toda su funcionalidad** a través de una **API REST** en el puerto **8006** (HTTPS).

**URL base:**
```
https://<servidor>:8006/api2/json/<ruta>
```

La API está **organizada jerárquicamente**:
- `/nodes/<nodo>` — operaciones sobre un nodo
- `/nodes/<nodo>/qemu/<vmid>` — gestión de VMs KVM
- `/nodes/<nodo>/lxc/<vmid>` — gestión de contenedores LXC
- `/cluster/...` — operaciones a nivel de clúster
- `/access/...` — autenticación y permisos

</div>

---

## Autenticación en la API

<div class="cols-2" style="margin-top:1.5rem">

<div class="card card-green">

### Tickets de sesión

Obtén un ticket con usuario y contraseña.

```bash
curl -k -d 'username=root@pam' \
  -d 'password=...' \
  https://proxmox.local:8006/api2/json/access/ticket
```

Úsalo en cabeceras `Cookie` y `CSRFPreventionToken`.

</div>

<div class="card card-purple">

### API Tokens (recomendado)

Genera un **token persistente** desde *Datacenter → Permissions → API Tokens*.

```bash
Authorization: PVEAPIToken=usuario@realm!token=uuid
```

**Ventajas:**
- No requiere mantener sesiones
- Permisos restringidos por token
- Fácil de revocar
- Ideal para automatización

</div>

</div>

---

## Clientes de línea de comandos

<table style="width:100%; font-size:0.75rem; margin-top:1rem">
<thead>
  <tr style="background:#f0f0f0">
    <th style="width:20%; text-align:left; padding:0.5rem">Cliente</th>
    <th style="width:55%; text-align:left; padding:0.5rem">Descripción y uso</th>
    <th style="width:25%; text-align:center; padding:0.5rem">Acceso</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd"><code>pveum</code></td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd">Gestión de usuarios, grupos, roles, ACLs y tokens</td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd; text-align:center">Local (nodo)</td>
  </tr>
  <tr>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd"><code>qm</code></td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd">Gestión de máquinas virtuales KVM (crear, clonar, snapshots, templates)</td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd; text-align:center">Local (nodo)</td>
  </tr>
  <tr>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd"><code>pct</code></td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd">Gestión de contenedores LXC (crear, clonar, snapshots, templates)</td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd; text-align:center">Local (nodo)</td>
  </tr>
  <tr>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd"><code>pvesm</code></td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd">Gestión de almacenamientos y volúmenes</td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd; text-align:center">Local (nodo)</td>
  </tr>
  <tr>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd"><code>pvesh</code></td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd"><strong>Cliente universal</strong> — acceso a cualquier endpoint de la API sin construir HTTP manualmente</td>
    <td style="padding:0.4rem; border-bottom:1px solid #ddd; text-align:center">Local (nodo)</td>
  </tr>
  <tr>
    <td style="padding:0.4rem"><code>pveclient</code></td>
    <td style="padding:0.4rem">Cliente remoto basado en red — administración desde fuera del clúster</td>
    <td style="padding:0.4rem; text-align:center">Remoto (red)</td>
  </tr>
</tbody>
</table>

---

## Ejemplos con `pvesh` — Cliente universal

<div style="margin-top:1rem">

```bash
pvesh get /nodes                               # Listar nodos
pvesh get /pools/Imagenes                      # Ver miembros de un pool
pvesh get /access/users --output-format json   # Listar usuarios en JSON
pvesh create /nodes/proxmox1/qemu --vmid 999 \
  --name nueva --memory 2048                   # Crear VM

pvesh set /nodes/proxmox1/qemu/321/config \
  --description "Plantilla Debian 12"          # Modificar configuración

pvesh delete /pools/Antiguo                    # Eliminar pool
```

</div>

---

## Documentación interactiva de la API

<div class="card card-yellow" style="margin-top:2rem">

### API Viewer

Proxmox incluye un **visualizador interactivo** muy útil accesible en:

```
https://<servidor>:8006/pve-docs/api-viewer/
```

**Permite:**
- Navegar por el árbol completo de la API
- Ver parámetros aceptados por cada endpoint
- Consultar respuestas esperadas
- Revisar privilegios requeridos

**Es el primer lugar donde acudir** cuando necesitas automatizar una acción.

</div>

---

## Scripts en Python con `proxmoxer`

<div class="card card-blue" style="margin-top:1.5rem">

### Librería proxmoxer

`proxmoxer` es la librería más usada para Python. Abstrae la API a una sintaxis muy natural.

```python
from proxmoxer import ProxmoxAPI

px = ProxmoxAPI('proxmox.iesgn.local', 
                user='josedom@iesgn',
                token_name='auto', 
                token_value='xxxx-xxxx-xxxx',
                verify_ssl=False)

# Listar VMs en el nodo
for vm in px.nodes('proxmox1').qemu.get():
    print(f"{vm['vmid']}: {vm['name']}")

# Crear una copia de seguridad
px.nodes('proxmox1').qemu(vm_id).backup.post()
```

📦 **Repositorio de scripts**: [Ejemplos avanzados de administración con proxmoxer](https://github.com/josedom24/scripts-proxmox-python)

</div>

---

## Scripts en Bash

<div class="card card-green" style="margin-top:1.5rem">

### Automatización con shell scripts

Bash es ideal para **scripts rápidos y ligeros** usando `curl` o `pvesh` directamente:

```bash
TOKEN="PVEAPIToken=josedom@iesgn!auto=xxxxxxxx-xxxx-xxxx-xxxx"

# Obtener información de una VM
curl -k -H "Authorization: $TOKEN" \
  https://proxmox.local:8006/api2/json/nodes/proxmox1/qemu/321

# O más simple con pvesh
pvesh get /nodes/proxmox1/qemu/321 --output-format json | jq '.data'
```

📂 **Repositorio de scripts**: [Colección de scripts bash para Proxmox](https://github.com/josedom24/scripts-proxmox-bash)

</div>

---

## Otros métodos de automatización

<div class="cols-2" style="margin-top:1.5rem">

<div class="card card-purple">

### Terraform

Infraestructura como código (IaC) para definir máquinas virtuales y recursos de forma declarativa y reproducible.

Provider oficial: `bpg/proxmox`

</div>

<div class="card card-orange">

### Ansible

Orquestación y configuración idempotente mediante la colección `community.general.proxmox`.

Facilita tareas repetitivas y gestión de máquinas a escala.

</div>

</div>

---

## Aplicación práctica en vuestro centro

<div class="card card-yellow" style="margin-top:1.5rem">

### Casos de uso principales

1. **Aprovisionamiento de alumnos**: Scripts con `pveum` + `pvesh` para crear usuarios, grupos, pools y ACLs a principio de curso desde un CSV.

2. **Automatización de plantillas**: Scripts que construyen plantillas de forma reproducible, garantizando que todas se preparan igual y pueden regenerarse ante actualizaciones.

3. **Limpieza periódica**: Detectar y eliminar VMs antiguas, snapshots olvidados, alumnos que ya no están matriculados.

4. **Monitorización de consumo**: Consultar la API periódicamente para avisar cuando un pool sobrepase ciertos umbrales de recursos.

</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">04</p>

# Ampliación y escalabilidad del sistema

## Evolución de la infraestructura

---

## Ampliación y escalabilidad del sistema

### Almacenamiento remoto SAN/NAS

- Centralización del almacenamiento
- Mayor capacidad y flexibilidad
- Independencia del servidor físico

### Clúster de alta disponibilidad

- Múltiples nodos Proxmox
- Migración en vivo de máquinas
- Redundancia y tolerancia a fallos
- Escalabilidad horizontal

---

<!-- _class: cierre -->
<!-- _paginate: false -->

# ¡Gracias!


<div style="margin-top:2rem; display:flex; gap:2rem; justify-content:center; font-size:0.85rem; color:#64748b">
  <span>📧 José Domingo Muñoz</span>
  <span>🏫 IES Gonzalo Nazareno · Dos Hermanas</span>
  <span>🌐 https://josedom24.github.io/curso_proxmox_2026</span>
</div>
