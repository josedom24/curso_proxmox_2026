---
marp: true
theme: profesional
paginate: true
header: 'Proxmox VE · Sesión 1 — Introducción a la virtualización'
footer: 'José Domingo Muñoz · IES Gonzalo Nazareno · 2026'
---

<!-- _class: portada -->
<!-- _paginate: false -->

# Virtualización con **Proxmox VE**

## Sesión 1 · Introducción a la virtualización

<p>José Domingo Muñoz &nbsp;·&nbsp; IES Gonzalo Nazareno &nbsp;·&nbsp; 2026</p>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">01</p>

# ¿Qué es la virtualización?

## Conceptos clave y soluciones de Proxmox VE

---

## Virtualización: la idea fundamental

> La virtualización usa software para imitar las características del hardware
> y crear sistemas informáticos virtuales sobre una misma máquina física.

<div class="cols-2" style="margin-top:1rem">

<div>

### Conceptos clave

- **Hipervisor**: software de virtualización que gestiona los recursos físicos y los reparte entre los sistemas invitados
- **Sistema anfitrión** (*host*): máquina física que ejecuta el hipervisor
- **Sistema invitado** (*guest*): sistema operativo que corre dentro del hipervisor

</div>

</div>

---

## Tipos de virtualización — Máquinas Virtuales

El hipervisor emula completamente el hardware físico. Los SO invitados se ejecutan **sin modificaciones**, usando extensiones del procesador (`Intel VT-x` / `AMD-V`) para acceso directo al hardware cuando es posible.

<div class="cols-2" style="margin-top:0.8rem">

<div class="card card-blue">

### Hipervisor tipo 1 *(bare-metal)*

- Se ejecuta **directamente sobre el hardware físico**, sin SO subyacente
- La CPU debe contar con extensiones de virtualización
- Rendimiento cercano al de una máquina física real
- KVM, aunque se ejecuta dentro del kernel Linux, **convierte ese kernel en hipervisor tipo 1**

**Ejemplos:** VMware ESXi, Microsoft Hyper-V, Xen, **KVM**

</div>

<div class="card card-green">

### Hipervisor tipo 2 *(hosteado)*

- Se ejecuta **sobre un SO anfitrión** que gestiona el acceso al hardware
- Introduce una capa adicional → **menor rendimiento** que el tipo 1
- Ideal para uso en escritorio, pruebas o desarrollo local

**Ejemplos:** VMware Workstation, VirtualBox, Parallels Desktop, VMware Player

<div class="alerta alerta-info" style="margin-top:0.6rem">
<span>ℹ️</span><div>QEMU puede actuar como tipo 2 por software, o como tipo 1 junto con KVM aprovechando las extensiones del procesador.</div>
</div>

</div>

</div>
---
## KVM — Kernel-based Virtual Machine

**KVM** es un hipervisor de tipo 1 integrado directamente en el kernel de Linux desde la versión 2.6.20 (2007).

<div class="cols-2" style="margin-top:0.8rem">

<div>

### Cómo funciona

- Convierte el kernel Linux en un hipervisor tipo 1
- Requiere extensiones de virtualización del procesador: `Intel VT-x` o `AMD-V`
- Cada máquina virtual es un **proceso normal** de Linux con acceso directo al hardware
- Se apoya en **QEMU** para emular los dispositivos de la VM (disco, red, USB…)
- Con **dispositivos paravirtualizados** (`virtio`), la VM accede directamente al hardware físico sin pasar por la emulación completa → **mayor rendimiento** (disco, red,...)
---

## Tipos de virtualización — Contenedores

La **virtualización ligera** no emula hardware: aísla procesos dentro del mismo SO. Cada contenedor comparte el kernel del host pero tiene su propio sistema de archivos, red y recursos.

<div class="cols-2" style="margin-top:0.8rem">

<div class="card card-purple">

### Contenedores de sistema

- Ejecutan una instancia aislada de un **SO completo**
- Cada contenedor tiene su propio espacio de usuario, red y almacenamiento
- Se comportan como una MV ligera, sin duplicar el kernel
- Arranque en segundos · consumo de RAM mínimo

**Ejemplo:** LXC *(Linux Containers)*

</div>

<div class="card card-blue">

### Contenedores de aplicación

- Diseñados para ejecutar **un servicio o aplicación** de forma aislada
- Más ligeros que los de sistema: no virtualizan el SO completo
- Ideales para microservicios y despliegues en la nube

**Ejemplos:** Docker, Podman, Kubernetes (orquestador de contenedores)

</div>

</div>

<div class="alerta alerta-warning" style="margin-top:0.6rem">
<span>⚠️</span><div>Los contenedores solo soportan sistemas <strong>Linux</strong> — comparten el kernel del host. No pueden correr Windows ni otros SO.</div>
</div>
---

## ¿Qué es Proxmox VE?

**Proxmox Virtual Environment** es una plataforma de virtualización de código abierto basada en Debian que integra en una sola interfaz web:

<div class="cols-2" style="margin-top:0.8rem">

<div>

### Lo que incluye

- Hipervisor **KVM** para máquinas virtuales completas
- **LXC** para contenedores Linux ligeros
- Gestión de **almacenamiento** (local, Ceph, NFS, iSCSI…)
- Gestión de **redes** (bridges, VLANs, SDN)
- **Clúster** y alta disponibilidad
- **Backups** integrados con Proxmox Backup Server

</div>

<div>

### Características destacadas

<div class="alerta alerta-ok"><span>✅</span><div>Interfaz web completa — sin cliente adicional</div></div>
<div class="alerta alerta-ok" style="margin-top:0.5rem"><span>✅</span><div>Código abierto — licencia AGPL</div></div>
<div class="alerta alerta-ok" style="margin-top:0.5rem"><span>✅</span><div>API REST completa para automatización</div></div>
<div class="alerta alerta-ok" style="margin-top:0.5rem"><span>✅</span><div>Comunidad activa y excelente documentación</div></div>
<div class="alerta alerta-warning" style="margin-top:0.5rem"><span>⚠️</span><div>Soporte empresarial de pago opcional</div></div>

</div>

</div>

---

## Las dos soluciones de Proxmox VE

<div class="cols-2" style="margin-top:1rem">

<div>

### Máquinas Virtuales (KVM)

```
┌─────────────────────────────┐
│   VM1 (Debian)  VM2 (Win)   │
│  ┌───────────┐ ┌──────────┐ │
│  │ Kernel    │ │ Kernel   │ │
│  │ propio    │ │ propio   │ │
│  └─────┬─────┘ └────┬─────┘ │
│        └──────┬─────┘       │
│          KVM/QEMU           │
│      (Proxmox VE host)      │
└─────────────────────────────┘
```

- Hardware **completamente emulado** (QEMU): red, disco, vídeo…
- Drivers **`virtio`** paravirtualizados → rendimiento casi nativo
- Cualquier SO: Linux, Windows, BSD...
- Snapshots y clonación incluidos

</div>

<div>

### Contenedores (LXC)

```
┌─────────────────────────────┐
│  CT101 (Ubuntu) CT102 (Deb) │
│  ┌───────────┐ ┌──────────┐ │
│  │ /bin /etc │ │ /bin/etc │ │
│  │ procesos  │ │ procesos │ │
│  └─────┬─────┘ └────┬─────┘ │
│        └──────┬─────┘       │
│       Kernel compartido     │
│      (Proxmox VE host)      │
└─────────────────────────────┘
```

- Arrancan en **segundos**
- 5–10× menos RAM que una VM
- Solo distribuciones **Linux**

</div>

</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">02</p>

# Proxmox VE vs otras soluciones

## Diferencias con OpenStack y otros sistemas

---

## Comparativa general

| Característica | **Proxmox VE** | OpenStack | VMware vSphere | oVirt |
|:---------------|:--------------:|:---------:|:--------------:|:-----:|
| Código abierto | ✅ | ✅ | ❌ | ✅ |
| Interfaz web integrada | ✅ | ⚠️ compleja | ✅ | ✅ |
| Curva de aprendizaje | Baja | Muy alta | Media | Media |
| KVM + LXC | ✅ | Solo KVM | ❌ | Solo KVM |
| Clúster y HA | ✅ | ✅ | ✅ | ✅ |
| Apto para educación | ✅✅ | ⚠️ | ⚠️ coste | ⚠️ |
| Instalación rápida | ✅ | ❌ semanas | ❌ | ❌ |

---

## Proxmox VE vs OpenStack

<div class="cols-2" style="margin-top:0.8rem">

<div>

### OpenStack

- Plataforma de **IaaS** (*Infrastructure as a Service*)
- Implementa los conceptos de **cloud computing** sobre hardware propio
- El usuario consume recursos como en AWS o Azure, pero en privado
- Abstrae completamente el hipervisor subyacente
- Arquitectura distribuida de servicios: Nova, Neutron, Cinder, Glance…
- Ideal para enseñar **cloud privado** y los módulos de cloud de ASIR

</div>

<div>

### Proxmox VE

- Plataforma de **virtualización tradicional**
- Gestión directa de hipervisor: el administrador controla cada VM
- No abstrae el hardware: se trabaja con nodos, almacenamiento y redes reales
- Arquitectura simple: un nodo ya es completamente funcional
- Ideal para enseñar **administración de sistemas** y virtualización

</div>

</div>

<div class="alerta alerta-info" style="margin-top:0.8rem">
<span>ℹ️</span><div>Aunque ambas permiten gestionar máquinas virtuales, parten de concepciones distintas: OpenStack modela una <strong>nube</strong>; Proxmox VE es un <strong>hipervisor gestionado</strong>. En un centro con ASIR, las dos tienen cabida.</div>
</div>
---

## ¿Por qué Proxmox VE para un centro educativo?

<div class="cols-3" style="margin-top:1.2rem">

<div class="card card-blue">

### Para el alumno

- Entorno **propio y aislado**
- Acceso desde el aula y desde casa
- Aprende con tecnología usada en la **industria**
- Puede romper y recrear sin consecuencias

</div>

<div class="card card-green">

### Para el profesor

- Despliegue de entornos en **minutos**
- Plantillas reutilizables por módulo
- Sin licencias de pago
- Panel web accesible desde cualquier navegador

</div>

<div class="card card-purple">

### Para el centro

- Hardware propio → **soberanía tecnológica**
- Coste reducido (open source)
- Escalable añadiendo nodos
- Comunidad activa y documentación excelente

</div>

</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">03</p>

# Evolución en el IES Gonzalo Nazareno

## De OpenStack a Proxmox VE

---

## Línea de tiempo (2011 — 2026)

<div class="steps" style="margin-top:2rem">
<div class="step hecho">2011</div>
<div class="step hecho">2014</div>
<div class="step hecho">2018</div>
<div class="step hecho">2022</div>
<div class="step activo">2026</div>
</div>

<div class="cols-2" style="margin-top:2rem">

<div>

**2011 — OpenStack pionero**
- Proyecto de innovación educativa de la Junta de Andalucía
- Primeros en España en usar OpenStack en FP
- Enseñanza de IaaS en módulos de ASIR

**2014–2018 — Consolidación**
- Infraestructura estable con OpenStack Juno → Queens
- Integración progresiva en el ciclo ASIR

</div>

<div>

**2018–2022 — Evolución**
- Simplificación progresiva de la instalación y administración de OpenStack
- Reflexión: ¿cómo llevar estos beneficios educativos a otros ciclos?

**2022 — Incorporación de Proxmox VE**
- Coexistencia con OpenStack desde el primer momento
- Proxmox VE se introduce en SMR y 1º ASIR

**2026 — Uso complementario consolidado**

</div>

</div>

---

## OpenStack en el IES (2011–hoy)

<div class="cols-2" style="margin-top:0.8rem">

<div>

### Lo que ha aportado

- Enseñanza real de conceptos de **nube privada** e IaaS
- Gestión de proyectos, usuarios y cuotas
- Redes virtuales con Neutron (SDN)
- Almacenamiento de objetos con Swift
- Primer contacto con **infraestructura como código**

### Hoy

- Instalación y administración **notablemente simplificadas**
- Plataforma principal en **2º ASIR**
- Referencia para enseñar cloud computing real

</div>

<div>

### Sus retos en educación

<div class="alerta alerta-warning"><span>⚠️</span><div>Curva de aprendizaje alta — exige conocimientos previos sólidos</div></div>
<div class="alerta alerta-warning" style="margin-top:0.5rem"><span>⚠️</span><div>Instalación y mantenimiento costosos en tiempo</div></div>
<div class="alerta alerta-warning" style="margin-top:0.5rem"><span>⚠️</span><div>Poco adecuado para alumnos de ciclos de grado medio</div></div>
<div class="alerta alerta-warning" style="margin-top:0.5rem"><span>⚠️</span><div>No incluye virtualización ligera (LXC)</div></div>

</div>

</div>

---

## Incorporación de Proxmox VE (2022)

<div class="cols-2" style="margin-top:0.8rem">

<div>

### La idea

Los beneficios educativos que encontramos en OpenStack — entornos propios por alumno, trabajo con infraestructura real, autonomía — merecían llegar a **más alumnos y más módulos**.

Proxmox VE permite trasladar esa experiencia con una instalación, administración y uso **más accesibles**, tanto para profesores como para alumnos.

### No es una sustitución

OpenStack y Proxmox VE **conviven** en el centro. Cada uno se usa donde aporta más valor pedagógico.

</div>

<div>

### Distribución actual

| Plataforma | Ciclo / Curso |
|:-----------|:--------------|
| **Proxmox VE** | 2º SMR |
| **Proxmox VE** | 1º ASIR |
| **OpenStack** | 2º ASIR |

<div class="alerta alerta-info" style="margin-top:0.8rem">
<span>ℹ️</span><div>El alumno que llega a 2º ASIR ya conoce la virtualización desde Proxmox VE — lo que facilita la comprensión del modelo de nube de OpenStack.</div>
</div>

</div>

</div>

### Ventajas percibidas de inmediato

<div class="alerta alerta-ok"><span>✅</span><div>Panel web intuitivo</div></div>
<div class="alerta alerta-ok" style="margin-top:0.4rem"><span>✅</span><div>VM y contenedores en la misma plataforma</div></div>
<div class="alerta alerta-ok" style="margin-top:0.4rem"><span>✅</span><div>Clonación de plantillas en segundos</div></div>
<div class="alerta alerta-ok" style="margin-top:0.4rem"><span>✅</span><div>Snapshots antes de cada práctica</div></div>
<div class="alerta alerta-ok" style="margin-top:0.4rem"><span>✅</span><div>Backups automatizados</div></div>
<div class="alerta alerta-ok" style="margin-top:0.4rem"><span>✅</span><div>Acceso noVNC sin cliente adicional</div></div>

</div>

</div>

---

## Impacto en las metodologías educativas

<div class="cols-2" style="margin-top:0.8rem">

<div>

### Antes

- Entornos compartidos → interferencias entre alumnos
- El profesor tenía que preparar los entornos manualmente
- Prácticas limitadas por el tiempo de despliegue
- Recuperación tras un error: horas

### Ahora con Proxmox VE

- Cada alumno tiene su **pool de recursos propio**
- Clonación de plantilla → entorno listo en **2 minutos**
- El alumno puede **borrar y recrear** sin pedir permiso
- Snapshot antes de la práctica → restauración en **30 segundos**

</div>

<div>

### Nuevas posibilidades pedagógicas

<span class="badge badge-blue">Escenarios complejos</span>

Redes con varios equipos interconectados, inaccesibles hace unos años por coste o complejidad.

<span class="badge badge-green">Reproducibilidad</span>

Todos los alumnos parten del mismo estado exacto al inicio de cada práctica.

<span class="badge badge-purple">Autonomía del alumno</span>

El alumno gestiona su propio entorno: crea, destruye, configura. Aprende haciendo.

<span class="badge badge-yellow">Continuidad</span>

Las máquinas virtuales persisten entre clases. El trabajo no se pierde.

</div>

</div>

---

<!-- _class: capitulo -->
<!-- _paginate: false -->

<p class="numero">04</p>

# Infraestructura del centro

## Hardware, red, almacenamiento y acceso

---

## Descripción general del entorno

<div class="cols-3" style="margin-top:1.2rem">

<div class="card card-blue kpi">
<div class="valor"><!-- TODO --></div>
<div class="etiqueta">Aulas</div>
<div class="sublabel">Con acceso a Proxmox</div>
</div>

<div class="card card-green kpi">
<div class="valor"><!-- TODO --></div>
<div class="etiqueta">Alumnos</div>
<div class="sublabel">Usuarios activos</div>
</div>

<div class="card card-purple kpi">
<div class="valor"><!-- TODO --></div>
<div class="etiqueta">Módulos</div>
<div class="sublabel">Que usan Proxmox VE</div>
</div>

</div>

<div class="cols-2" style="margin-top:1.2rem">

<div>

### Módulos que usan Proxmox VE

- <!-- TODO: listar módulos (ej. ASIR, SMR, DAM...) -->

</div>

<div>

### Versión en producción

<span class="badge badge-blue">Proxmox VE <!-- TODO: versión --></span>

- Política de actualizaciones: <!-- TODO -->
- Repositorio: `pve-no-subscription` / enterprise

</div>

</div>

---

## Servidores físicos del CPD

| Nodo | Modelo | CPU | RAM | Almacenamiento |
|:-----|:-------|:----|:----|:---------------|
| pve1 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| pve2 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| pve3 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |

<div class="cols-2" style="margin-top:1rem">

<div>

### Configuración de los nodos

- Modo de operación: <!-- TODO: standalone / clúster -->
- Migración en vivo: <!-- TODO: sí/no -->
- Alta disponibilidad: <!-- TODO: configurada/planificada -->

</div>

<div>

<div class="alerta alerta-info">
<span>ℹ️</span><div>Con un solo nodo Proxmox VE ya es completamente funcional. El clúster añade redundancia y migración en vivo pero no es imprescindible para empezar.</div>
</div>

</div>

</div>

---

## Diagrama de infraestructura

```
                    Internet
                       │
               ┌───────▼────────┐
               │   Firewall /   │
               │  Proxy inverso │
               └───────┬────────┘
                        │
               ┌────────▼───────┐
               │    Switch CPD  │  VLANs: gestión / alumnos / storage
               └──┬──────┬──────┘
          ┌───────┘      └──────────┐
   ┌──────▼──────┐          ┌───────▼──────┐
   │   Nodo pve1  │  . . .   │   Nodo pveN  │
   │  KVM + LXC  │          │  KVM + LXC  │
   └──────┬──────┘          └───────┬──────┘
          └──────────┬──────────────┘
               ┌─────▼──────┐
               │ Almacena-  │  Local ZFS / Ceph / NFS
               │  miento    │
               └────────────┘
```

<!-- TODO: sustituir por diagrama real del centro -->

---

## Red interna del CPD

<div class="cols-2" style="margin-top:0.8rem">

<div>

### Switches y conectividad

- Switch principal: <!-- TODO: modelo -->
- Velocidad de enlace entre nodos: <!-- TODO: 1/10/25 GbE -->
- Red de almacenamiento separada: <!-- TODO: sí/no -->

### VLANs configuradas

| VLAN | Uso |
|:-----|:----|
| <!-- TODO --> | Gestión Proxmox |
| <!-- TODO --> | Máquinas de alumnos |
| <!-- TODO --> | Almacenamiento / Ceph |
| <!-- TODO --> | Acceso externo |

</div>

<div>

### Redes en Proxmox VE

- Bridge principal: `vmbr0`
- Bridge de prácticas: `vmbr1` (aislado)
- Soporte de VLANs con `vlan-aware: yes`

<div class="alerta alerta-info">
<span>ℹ️</span><div>Las redes internas de prácticas permiten a los alumnos montar topologías complejas sin afectar a la red real del centro.</div>
</div>

</div>

</div>

---

## Almacenamiento

<div class="cols-2" style="margin-top:0.8rem">

<div>

### Tipos de almacenamiento en uso

| Storage | Tipo | Uso |
|:--------|:-----|:----|
| `local` | Dir / ZFS | ISOs, backups |
| `local-lvm` | LVM-thin | Discos de VM y CT |
| <!-- TODO --> | Ceph / NFS | <!-- TODO --> |

### Capacidad total

- Almacenamiento bruto: <!-- TODO --> TB
- Disponible para VMs: <!-- TODO --> TB
- Política de cuotas por alumno: <!-- TODO -->

</div>

<div>

### Tipos de disco

- <!-- TODO: SSD NVMe / SAS / SATA -->

### Consideraciones

<div class="alerta alerta-ok"><span>✅</span><div>ZFS ofrece snapshots instantáneos y compresión transparente</div></div>
<div class="alerta alerta-warning" style="margin-top:0.5rem"><span>⚠️</span><div>Ceph requiere mínimo 3 nodos para producción</div></div>
<div class="alerta alerta-info" style="margin-top:0.5rem"><span>ℹ️</span><div>LVM-thin es la opción más común en instalaciones con un solo nodo</div></div>

</div>

</div>

---

## Acceso de los alumnos

<div class="cols-2" style="margin-top:0.8rem">

<div>

### Desde el aula

1. El alumno abre el navegador
2. Accede a `https://proxmox.gonzalonazareno.org`
3. Se autentica con sus credenciales LDAP
4. Gestiona sus VMs desde la interfaz web
5. Accede a la consola vía **noVNC** (sin cliente)

</div>

<div>

### Desde casa

<div class="alerta alerta-info">
<span>ℹ️</span><div>Acceso remoto disponible mediante:</div>
</div>

- **Proxy inverso** (Nginx / Caddy) con certificado TLS
- <!-- TODO: VPN / Guacamole / acceso directo con firewall -->
- Misma experiencia que desde el aula

</div>

</div>

<div class="alerta alerta-ok" style="margin-top:1rem">
<span>✅</span><div>El acceso por <strong>noVNC</strong> integrado en Proxmox VE elimina la necesidad de instalar cualquier software en el equipo del alumno. Solo hace falta un navegador moderno.</div>
</div>

---

## Seguridad perimetral

<div class="cols-3" style="margin-top:1.2rem">

<div class="card card-blue">

### Firewall

- <!-- TODO: pfSense / nftables / otro -->
- Reglas de entrada/salida por VLAN
- Aislamiento entre redes de alumnos
- Proxmox FW interno por VM

</div>

<div class="card card-green">

### Proxy inverso

- <!-- TODO: Nginx / Caddy / HAProxy -->
- Terminación TLS centralizada
- Certificados **Let's Encrypt** (automáticos)
- Oculta puertos internos de Proxmox

</div>

<div class="card card-purple">

### Autenticación

- Directorio **LDAP** del centro
- Roles y permisos por usuario/grupo
- Sin contraseñas locales en Proxmox
- Registro de acciones (audit log)

</div>

</div>

---

<!-- _class: cierre -->
<!-- _paginate: false -->

# ¡Gracias!

## Sesión 2 → Uso básico de Proxmox VE

<div style="margin-top:2rem; display:flex; gap:2rem; justify-content:center; font-size:0.85rem; color:#64748b">
  <span>📧 josedom24@gmail.com</span>
  <span>🏫 IES Gonzalo Nazareno · Dos Hermanas</span>
  <span>🌐 proxmox.com/proxmox-ve</span>
</div>