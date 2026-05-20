#!/bin/bash
# Elimina los usuarios y grupos creados por 01_crear_usuarios.sh
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REALM="pve"

declare -A GRUPOS=(
    [smr]="$SCRIPT_DIR/smr.txt"
    [asir]="$SCRIPT_DIR/asir.txt"
    [profesores]="$SCRIPT_DIR/profesores.txt"
)

# Eliminar usuarios
for grupo in "${!GRUPOS[@]}"; do
    fichero="${GRUPOS[$grupo]}"

    if [[ ! -f "$fichero" ]]; then
        echo "[ERROR] No se encuentra el fichero: $fichero"
        continue
    fi

    echo "--- Eliminando usuarios del grupo: $grupo ---"

    while IFS=',' read -r usuario password; do
        [[ -z "$usuario" || "$usuario" == \#* ]] && continue
        userid="${usuario}@${REALM}"

        if pvesh get /access/users/"$userid" &>/dev/null; then
            pveum user delete "$userid"
            echo "  [OK] Usuario eliminado: $userid"
        else
            echo "  [NO EXISTE] $userid"
        fi
    done < "$fichero"

    echo ""
done

# Eliminar grupos
for grupo in "${!GRUPOS[@]}"; do
    if pvesh get /access/groups/"$grupo" &>/dev/null; then
        pveum group delete "$grupo"
        echo "  [OK] Grupo eliminado: $grupo"
    else
        echo "  [NO EXISTE] Grupo: $grupo"
    fi
done

echo ""
echo "=== Hecho. Usuarios y grupos eliminados de Proxmox. ==="
