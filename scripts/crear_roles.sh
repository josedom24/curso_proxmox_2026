#!/bin/bash
# Crea los roles personalizados en Proxmox VE
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

crear_rol() {
    local nombre="$1"
    local privs="$2"

    if pveum role list | grep -q "^${nombre} "; then
        echo "  [YA EXISTE] Rol: $nombre"
    else
        pveum role add "$nombre" --privs "$privs"
        echo "  [OK] Rol creado: $nombre"
    fi
}

# Rol usuario: gestión completa de VMs en su pool
crear_rol "usuario" \
    "Datastore.AllocateSpace,Datastore.Audit,\
Permissions.Modify,Pool.Audit,SDN.Use,\
Sys.Audit,Sys.Console,Sys.Modify,Sys.Syslog,\
VM.Allocate,VM.Audit,VM.Backup,VM.Clone,VM.Console,\
VM.Migrate,VM.Monitor,VM.PowerMgmt,VM.Snapshot,VM.Snapshot.Rollback,\
VM.Config.CDROM,VM.Config.CPU,VM.Config.Cloudinit,VM.Config.Disk,\
VM.Config.HWType,VM.Config.Memory,VM.Config.Network,VM.Config.Options"

# Rol red: administración de redes SDN
crear_rol "red" \
    "SDN.Allocate,SDN.Audit,SDN.Use,Sys.Modify"

# Rol template-clone: solo puede clonar plantillas existentes
crear_rol "template-clone" \
    "Pool.Audit,VM.Audit,VM.Clone"

# Rol template-create: puede crear nuevas plantillas
crear_rol "template-create" \
    "Pool.Allocate,VM.Allocate"

echo ""
echo "=== Hecho. Verifica con: pveum role list ==="
