---
marp: true
theme: profesional
title: "Proxmox VE"
paginate: true
header: 'Proxmox VE · Sesión 3 — Almacenamiento y redes en Proxmox VE'
---

<!-- _class: portada -->
<!-- _paginate: false -->

# Almacenamiento y redes en **Proxmox VE**

## Sesión 3 · Almacenamiento y redes en Proxmox VE

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

# Gestión de almacenamiento en Proxmox VE

## Configuración y administración de almacenamiento

---

## Almacenamiento en Proxmox VE

Proxmox permite gestionar varios tipos de almacenamiento:

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-blue">

### Almacenamiento local

- **local** (Directory) — almacenamiento en carpetas
- **local-lvm** (LVM) — almacenamiento en volúmenes lógicos
- Almacenamiento **directo** en el nodo

</div>
<div class="card card-green">

### Almacenamiento remoto

- **NFS** — acceso a recursos compartidos de red
- **iSCSI** — almacenamiento en bloque de red
- **Ceph** — almacenamiento distribuido de alta disponibilidad

</div>
</div>

---

## Tipos de almacenamiento disponibles

<div class="cols-2" style="margin-top:0.8rem">
<div>

**Directory (local)**
- Almacenamiento simple basado en carpetas
- Ideal para almacenar ISOs, backups y plantillas
- Acceso directo al sistema de ficheros

</div>
<div>

**LVM-Thin (local-lvm)**
- Volúmenes lógicos con aprovisionamiento dinámico
- Ideal para discos de máquinas virtuales
- Mejor utilización del espacio disponible

</div>
</div>

---

## Gestión de almacenamiento desde Proxmox

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-purple">

**Navegación**
- Panel izquierdo → **Datacenter** → **Almacenamiento**
- Lista de todos los almacenamientos disponibles
- Información sobre uso y capacidad

</div>
<div class="card card-yellow">

**Operaciones**
- Ver detalles de cada almacenamiento
- Monitorizar capacidad y uso
- Añadir nuevo almacenamiento remoto
- Gestionar contenido (ISOs, backups)

</div>
</div>

---

## Carga de ISOs en Proxmox

<div class="alerta alerta-info">ℹ️ Las ISOs se almacenan en el almacenamiento local <strong>Directory</strong>.</div>

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-blue">

**Paso 1: Acceder al almacenamiento**
- Datacenter → Almacenamiento → **local**
- Pestaña **Contenido**

</div>
<div class="card card-green">

**Paso 2: Subir archivo**
- Botón **Cargar** → seleccionar archivo ISO
- La carga se realiza al servidor Proxmox

</div>
</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">02</p>

# DEMO 1: Gestión de discos en MV y en contenedores

## Configuración y administración de almacenamiento

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">03</p>

# Introducción a la gestión de redes con Proxmox VE

## Configuración de interfaces y bridges virtuales

---

## Redes en Proxmox VE

La configuración de red se realiza a través de **bridges virtuales** que conectan máquinas virtuales y contenedores.

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-blue">

### Concepto de Bridge

Un **bridge** actúa como un conmutador virtual:
- Conecta interfaces físicas y virtuales
- Permite comunicación entre VMs/CTs
- Acceso a la red externa

</div>
<div class="card card-purple">

### Interfaces de red

- **Interfaz física** (ej: `eno1`) → conecta al hardware real
- **Bridge virtual** (ej: `vmbr0`) → punto de conexión para VMs/CTs
- **VLAN** — segmentación de red en el mismo bridge

</div>
</div>

---

## Configuración de red en Proxmox

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-green">

**Acceso a la configuración**
- Panel izquierdo → seleccionar nodo → **Red**
- Vista actual de interfaces y bridges

</div>
<div class="card card-yellow">

**Información disponible**
- Estado de cada interfaz
- Configuración de IP (estática o DHCP)
- Bridges y VLANs activos

</div>
</div>

<div class="alerta alerta-warning">⚠️ Cambios en la red requieren <strong>reinicio</strong> del sistema o <strong>aplicación manual</strong> de la configuración.</div>

---

## Crear un bridge virtual

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-blue">

**Pasos**
1. Panel de Red → **Crear Bridge**
2. Asignar nombre (ej: `vmbr1`)
3. Seleccionar interfaz **física** (ej: `eno1`)
4. Configurar IP (opcional)

</div>
<div class="card card-red">

**Cuidado**
- El bridge principal (`vmbr0`) conecta el host a la red
- No eliminar ni modificar el bridge activo
- Hacer cambios con **acceso local** disponible

</div>
</div>

---

## Configuración de red en máquinas virtuales

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-purple">

**Asignación de bridge a VM**
- Seleccionar la VM → **Hardware**
- **Red** → seleccionar bridge disponible (ej: `vmbr0`)
- El modelo predeterminado es **VirtIO** (recomendado)

</div>
<div class="card card-green">

**Configuración IP en la VM**
- DHCP automático (si hay servidor DHCP)
- IP estática (configurar dentro del SO invitado)

</div>
</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">04</p>

# DEMO 2: Introducción a la gestión de redes con Proxmox VE

## Configuración de interfaces y bridges virtuales

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">05</p>

# Clonación, plantillas, snapshots y backup de máquinas virtuales

## Gestión avanzada de máquinas virtuales

---

## Clonación de máquinas virtuales

La clonación duplica una máquina virtual existente con toda su configuración.

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-blue">

**Pasos**
1. Seleccionar la VM
2. Botón derecho → **Clonar**
3. Asignar nuevo **nombre** e **ID**
4. Seleccionar almacenamiento

</div>
<div class="card card-green">

**Tipo de clonación**
- **Copia completa** — duplica discos (más lento, independiente)
- **Enlace** — discos vinculados (más rápido, comparte datos)

</div>
</div>

<div class="alerta alerta-warning">⚠️ La VM original debe estar <strong>detenida</strong> para clonar.</div>

---

## Plantillas de máquinas virtuales

Una **plantilla** es una máquina virtual preconfigurada que sirve como base para crear nuevas máquinas rápidamente.

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-purple">

**Crear plantilla**
1. Configurar una VM con el SO e instalaciones necesarias
2. Preparar la VM (limpiar, actualizar)
3. Seleccionar VM → **Convertir a plantilla**
4. La VM se marca como plantilla (no se puede ejecutar directamente)

</div>
<div class="card card-yellow">

**Usar plantilla**
1. Clic derecho en plantilla → **Clonar**
2. Asignar nombre a la nueva VM
3. La clonación crea una VM completa independiente

</div>
</div>

---

## Ventajas de las plantillas

<div class="cols-3" style="margin-top:1rem">

<div class="card card-blue">

### Tiempo

Crear MV nuevas en **minutos** en lugar de horas

</div>

<div class="card card-green">

### Consistencia

Todas las MV tienen la **misma configuración base**

</div>

<div class="card card-purple">

### Mantenimiento

Actualizar la plantilla → aplicar cambios a futuras MV

</div>

</div>

---

## Snapshots (instantáneas)

Un **snapshot** es una fotografía del estado de una máquina en un momento concreto.

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-blue">

**Crear snapshot**
- VM → **Snapshot** → **Crear Snapshot**
- Asignar nombre descriptivo
- Esperar a que se complete la operación

</div>
<div class="card card-green">

**Restaurar snapshot**
- VM → **Snapshot** → Seleccionar snapshot
- **Restaurar**
- La VM vuelve al estado guardado (datos posteriores se pierden)

</div>
</div>

<div class="alerta alerta-warning">⚠️ Los snapshots consumen espacio en disco. No son <strong>copias de seguridad</strong>.</div>

---

## Casos de uso de snapshots

<div class="cols-3" style="margin-top:1rem">

<div class="card card-purple">

### Antes de cambios

Crear snapshot antes de actualizar SO o cambiar configuración

</div>

<div class="card card-yellow">

### Experimentación

Probar cambios arriesgados sabiendo que se puede volver atrás

</div>

<div class="card card-red">

### Recuperación rápida

Restaurar a un estado conocido sin reinstalar

</div>

</div>

---

## Backups en Proxmox VE

Un **backup** es una copia de seguridad independiente, almacenada en un lugar seguro.

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-blue">

**Crear backup**
- VM → **Backup**
- Seleccionar almacenamiento de destino
- Elegir si incluir discos o solo configuración
- Ejecutar backup

</div>
<div class="card card-green">

**Restaurar desde backup**
- Datacenter → **Backups**
- Seleccionar backup
- **Restaurar** → asignar nuevo nombre/ID

</div>
</div>

---

## Diferencias: Snapshot vs Backup

| Característica | Snapshot | Backup |
|:---|:---:|:---:|
| **Ubicación** | Mismo almacenamiento | Almacenamiento separado |
| **Propósito** | Cambios temporales | Copia de seguridad |
| **Tiempo de restauración** | Rápido | Más lento |
| **Retención** | Corta (no confundir con protección) | Larga (política de retención) |
| **Compresión** | No | Sí (opcionalmente) |

---

## Planificación de backups

<div class="cols-2" style="margin-top:0.8rem">
<div class="card card-purple">

**Backup remoto**
- Enviar backups a un servidor externo (NFS, iSCSI)
- Protección contra fallos del almacenamiento local
- Proxmox Backup Server para automatización

</div>
<div class="card card-yellow">

**Estrategia recomendada**
- Backups regulares (diarios o semanales)
- Múltiples copias en diferentes ubicaciones
- Probar restauración periódicamente

</div>
</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">06</p>

# DEMO 3: Clonación, plantillas, snapshots y backups

## Gestión avanzada de máquinas virtuales


---

## Recursos

- [Curso de introducción a Proxmox VE (CEP Castilleja de la Cuesta)](https://github.com/iesgn/curso_proxmox_cep)
  - Capítulo 4: Gestionando el almacenamiento
  - Capítulo 5: Clonación, instantáneas y copias de seguridad
  - Capítulo 7: Introducción a las redes en Proxmox
- Prácticas con alumnos:
  - [Práctica 4: Clonación, plantillas y snapshots en Proxmox](https://raw.githubusercontent.com/josedom24/presentaciones/main/hlcgm/practica4.pdf)
  - [Práctica 6: Instalación de contenedores en Proxmox](https://raw.githubusercontent.com/josedom24/presentaciones/main/hlcgm/practica6.pdf)
  - [Práctica 7: Trabajando con redes en Proxmox](https://raw.githubusercontent.com/josedom24/presentaciones/main/hlcgm/practica7.pdf)
  - [ráctica 8: Almacenamiento en Proxmox](https://raw.githubusercontent.com/josedom24/presentaciones/main/hlcgm/practica8.pdf)

---

<!-- _class: cierre -->
<!-- _paginate: false -->

# ¡Gracias!

## Sesión 4 → Configuración específica de Proxmox VE en el IES Gonzalo Nazareno

<div style="margin-top:2rem; display:flex; gap:2rem; justify-content:center; font-size:0.85rem; color:#64748b">
  <span>📧 José Domingo Muñoz</span>
  <span>🏫 IES Gonzalo Nazareno · Dos Hermanas</span>
  <span>🌐 https://josedom24.github.io/curso_proxmox_2026</span>
</div>
