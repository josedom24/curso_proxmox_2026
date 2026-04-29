---
marp: true
theme: profesional
title: "Proxmox VE"
paginate: true
header: 'Proxmox VE · Sesión 2 — Uso básico de Proxmox VE'
---

<!-- _class: portada -->
<!-- _paginate: false -->

# Uso básico de **Proxmox VE**

## Sesión 2 · Uso básico de Proxmox VE

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

# DEMO 1: Gestión de máquinas virtuales Linux

## Creación, configuración y administración

---

## Creación de una MV Linux en Proxmox (1)

<div class="cols-2">
<div class="card card-red">

- Usamos el botón **Crear VM**.
- **Nombre** obligatorio; 
- Si estamos usando **Conjuntos de recursos** para guardar la MV indicamos el nombre.
- Elegimos la **ISO** del almacenamiento local.
- Seleccionamos el **tipo de SO y versión**.

</div>
<div class="card card-blue">

- Tarjeta gráfica, tipo de máquina, BIOS y controlador VirtIO SCSI → **valores por defecto**.
- Escogemos los **discos**; por defecto se añade uno. **Podemos añadir más**.
- Disco en **local-lvm**; indicar el **tamaño**.

</div>
</div>

---

## Creación de una MV Linux en Proxmox (2)

<div class="cols-2">
<div class="card card-blue">

- **Zócalo (Socket)** — ranura física en la placa base.
- **Núcleo (Core)** — unidad de procesamiento dentro del socket.
- Elegimos cuántos **Sockets y Cores** tendrá la MV.

Elige **host** para virtualización anidada (la MV hereda las características de CPU del host).


</div>
<div class="card card-yellow">

- Indicamos la **cantidad de memoria**.
- **Red**: conectada a **vmbr0** → IP por DHCP.
- Modelo de tarjeta **VirtIO** y MAC predeterminados.

</div>
</div>

---

## Gestión de máquinas virtuales

Acciones disponibles mediante **botón derecho** sobre la MV:

<div class="cols-2">
<div class="card card-purple">

- **Iniciar** — inicia la ejecución.
- **Pause** — pausa; reanudar con **Resume**.
- **Hibernate** — guarda estado en memoria.
- **Cierre ordenado** — apagado limpio.

</div>
<div class="card card-green">

- **Parar** — termina inmediatamente.
- **Clonar** — duplica la máquina.
- **Convertir a plantilla** — crea una plantilla.
- **Consola** — abre terminal de la MV.

</div>
</div>

---

## Gestión de máquinas virtuales

Secciones del **panel lateral**:

<div class="cols-2">
<div class="card card-red">

- **Resumen** — estado y monitorización.
- **Consola** — terminal de la máquina.
- **Hardware** — ver y modificar el hardware.
- **Opciones** — configurar parámetros.

</div>
<div class="card card-blue">

- **Historial de Tareas** — registro de acciones.
- **Copia de seguridad** — gestión de backups.
- **Snapshot** — crear/restaurar instantáneas.

</div>
</div>

---

## Eliminar una máquina virtual

<div class="alerta alerta-danger">🛑 La máquina debe estar <strong>parada</strong> antes de poder eliminarla.</div>

- Escoger la opción **Eliminar** del botón **Más**.
- Se pedirá el **identificador** de la MV para confirmar.

## Opciones de máquinas virtuales

<div class="alerta alerta-warning">⚠️ Algunos cambios requieren <strong>reinicio</strong> para aplicarse.</div>

- **Nombre**, **Tipo de OS**, **Orden de arranque**.

---

## Hardware de la máquina virtual

- Ver y modificar RAM, CPU, BIOS, Display y dispositivos conectados.
- Podemos **añadir nuevos dispositivos** y eliminarlos.

<div class="alerta alerta-warning">⚠️ El cambio de hardware requiere <strong>reinicio</strong> de la máquina.</div>

## Qemu-guest-agent

<div class="cols-2">
<div>

Demonio en la MV que permite comunicación con Proxmox: muestra la **IP**, facilita apagados ordenados y snapshots consistentes. Activar la opción en la configuración de la MV.

</div>
<div>

```bash
apt install qemu-guest-agent
```

<span class="badge badge-green">Recomendado en todas las MV</span>

</div>
</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">02</p>

# DEMO 2: Gestión de máquinas virtuales Windows

## Particularidades y configuración específica

---

## Windows en Proxmox

Los pasos son similares a los de una MV Linux, pero con una diferencia clave:

<div class="cols-2">
<div class="card card-yellow">

**¿Qué cambia?**
- Disco duro e interfaz de red de tipo **VirtIO** → mayor rendimiento.
- Windows **no incluye** los drivers para dispositivos VirtIO.

</div>
<div class="card card-blue">

**Solución**
Añadir un segundo CDROM con los **drivers VirtIO** de Proxmox antes de iniciar la instalación.

</div>
</div>
<div class="alerta alerta-info">ℹ️ Debes subir al <strong>almacenamiento local</strong> la ISO de los drivers VirtIo (<a href="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/?C=M;O=D">Descarga</a>).</div>

<div class="alerta alerta-info">ℹ️ (<a href="https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers">Windows VirtIO Drivers</a>).</div>

---

## Creación de una MV Windows en Proxmox

<div class="cols-2">
<div class="card card-green">

- SO: **Microsoft Windows** + versión correspondiente.
- Tipo de disco **Bus/device** → **VirtIO Block**.

</div>

<div class="card card-purple">

- **Añadir CDROM con drivers VirtIO**
- Máquina → **Hardware** → **Agregar** → **Dispositivo CD/DVD**.
- **Configurar orden de arranque**
- **Opciones** → **Orden de arranque**: la ISO de Windows debe estar por encima de la ISO de drivers VirtIO.
</div>

</div>
<div class="alerta alerta-info">ℹ️ Una vez configurado el orden de arranque, ya podemos <strong>iniciar la máquina</strong>.</div>

---

## Comienzo de la instalación

Durante la instalación, Windows no detecta el disco duro porque no tiene los drivers VirtIO.

1. En la pantalla de selección de disco → **Cargar contr.** → **Examinar**.
2. Del CDROM de drivers seleccionamos la carpeta `amd64` de nuestra **versión de Windows**.
3. Con el driver cargado, Windows detecta el disco y podemos continuar.

<div class="alerta alerta-warning">⚠️ Sin este paso <strong>no aparecerá ningún disco</strong> disponible para la instalación.</div>

---

## Configuración de red

<div class="alerta alerta-danger">🛑 Sin drivers VirtIO, Windows <strong>no tiene conexión de red</strong> tras la instalación.</div>

Instalar drivers desde el **Administrador de dispositivos**:

1. Buscar **Controladora Ethernet** → **Actualizar controlador**.
2. Seleccionar la carpeta del CDROM de drivers VirtIO:

<div class="card card-blue">

`NetKVM\<versión_windows>\amd64`

</div>

---

## Qemu-guest-agent

<div class="cols-2">
<div>

Demonio que permite comunicación con Proxmox: muestra la **IP**, facilita apagados ordenados y snapshots consistentes. Activar la opción en la configuración de la MV.

</div>
<div>

**En la MV Windows:**
1. **Administrador de Dispositivos**.
2. Buscar **PCI Simple Communications Controller**.
3. **Actualizar controlador** → seleccionar del CDROM de drivers VirtIO.

<span class="badge badge-green">Recomendado en todas las MV</span>

</div>
</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">03</p>

# DEMO 3: Gestión de contenedores LXC

## Contenedores ligeros y su administración

---

## Contenedores en Proxmox

<div class="cols-2">
<div class="card card-blue">

**¿Qué es un contenedor?**
Conjunto de procesos que se ejecutan en el host con su propio **sistema de ficheros** y **configuración de red**. Se puede considerar una **mini máquina virtual**.

- Comparten el **kernel del host** → más ligeros y rápidos.
- Todos los contenedores son **Linux**.

</div>
<div class="card card-green">

**Ejemplos:** Docker, LXC, ...

**En Proxmox** trabajamos con contenedores **LXC**.

Mayor eficiencia que las MV a cambio de menor aislamiento respecto al host.

</div>
</div>

---

## Crear un contenedor

Desde el botón **Crear CT** lanzamos el asistente de configuración.

<div class="cols-2">
<div class="card card-purple">

**Campos obligatorios**
- **Nombre del Host** — identificador del contenedor.
- **Conjunto de recursos** (si lo estamos utilizando).
- **Contraseña** del usuario **root**.

</div>
<div class="card card-blue">

**Opcional**
- **Clave SSH pública** para acceso por SSH sin contraseña.

</div>
</div>

---

## Elegimos el sistema operativo (Plantilla)

<div class="cols-2">
<div class="card card-yellow">

**¿Qué es una plantilla?**
Imagen de SO preconfigurada que sirve de base para el contenedor. Se descarga del repositorio de Proxmox y se almacena en el **almacenamiento local**.

</div>
<div class="card card-red">

**Configuración del contenedor** (similar a las MV):
- **Disco** — tamaño del almacenamiento.
- **CPU** — número de cores.
- **Memoria** — RAM asignada.
- **Red** — interfaz y configuración de red.

</div>
</div>

<div class="alerta alerta-info">ℹ️ La gestión y eliminación de contenedores es <strong>similar a la de las MV</strong>.</div>

---

## Inicio del contenedor

<div class="alerta alerta-warning">⚠️ Al crear el contenedor, el único usuario disponible es <strong>root</strong>.</div>

- Iniciamos el contenedor desde el panel de control.
- Accedemos a él mediante la **Consola** de Proxmox o por **SSH**.

---

## Recursos

- [Curso de introducción a Proxmox VE (CEP Castilleja de la Cuesta)](https://github.com/iesgn/curso_proxmox_cep)
  - Capítulo 3: Creación de máquinas virtuales
  - Capítulo 7: Trabajando con Linux Containers
- Prácticas con alumnos:
  - [Práctica 1: Instalación de una máquina Linux en Proxmox](https://raw.githubusercontent.com/josedom24/presentaciones/main/hlcgm/practica1.pdf)
  - [Práctica 2: Instalación de una máquina Windows en Proxmox](https://raw.githubusercontent.com/josedom24/presentaciones/main/hlcgm/practica2.pdf)
  - [Práctica 3: Trabajo con claves SSH](https://raw.githubusercontent.com/josedom24/presentaciones/main/hlcgm/practica3.pdf)
  - [Práctica 6: Instalación de contenedores en Proxmox](https://raw.githubusercontent.com/josedom24/presentaciones/main/hlcgm/practica6.pdf)

---

<!-- _class: cierre -->
<!-- _paginate: false -->

# ¡Gracias!

## Sesión 3 → Almacenamiento y redes en Proxmox VE

<div style="margin-top:2rem; display:flex; gap:2rem; justify-content:center; font-size:0.85rem; color:#64748b">
  <span>📧 José Domingo Muñoz</span>
  <span>🏫 IES Gonzalo Nazareno · Dos Hermanas</span>
  <span>🌐 https://josedom24.github.io/curso_proxmox_2026</span>
</div>
