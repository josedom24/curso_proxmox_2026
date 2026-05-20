#!/bin/bash
# Elimina los roles personalizados creados por crear_roles.sh
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

ROLES=("usuario" "red" "template-clone" "template-create")

for rol in "${ROLES[@]}"; do
    if pveum role list | grep -q "^${rol} "; then
        pveum role delete "$rol"
        echo "  [OK] Rol eliminado: $rol"
    else
        echo "  [NO EXISTE] Rol: $rol"
    fi
done

echo ""
echo "=== Hecho. Verifica con: pveum role list ==="
