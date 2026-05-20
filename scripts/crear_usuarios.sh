#!/bin/bash
# Crea grupos y usuarios en Proxmox VE a partir de los ficheros smr.txt, asir.txt y profesores.txt
# Formato de cada fichero: usuario,contraseña (una por línea)
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REALM="pve"

declare -A GRUPOS=(
    [smr]="$SCRIPT_DIR/smr.txt"
    [asir]="$SCRIPT_DIR/asir.txt"
    [profesores]="$SCRIPT_DIR/profesores.txt"
)

# Crear grupos
for grupo in "${!GRUPOS[@]}"; do
    if pveum group list | grep -q "${grupo}"; then
        echo "  [YA EXISTE] Grupo: $grupo"
    else
        pveum group add "$grupo" --comment "Grupo $grupo"
        echo "  [OK] Grupo creado: $grupo"
    fi
done

echo ""

# Crear usuarios y asignarlos a su grupo
for grupo in "${!GRUPOS[@]}"; do
    fichero="${GRUPOS[$grupo]}"

    if [[ ! -f "$fichero" ]]; then
        echo "[ERROR] No se encuentra el fichero: $fichero"
        continue
    fi

    echo "--- Procesando grupo: $grupo ---"

    while IFS=',' read -r usuario password; do
        [[ -z "$usuario" || "$usuario" == \#* ]] && continue
        userid="${usuario}@${REALM}"

        if pveum user list | grep -q "^${userid} "; then
            echo "  [YA EXISTE] $userid"
        else
            pveum user add "$userid" --password "$password" --groups "$grupo"
            echo "  [OK] Usuario creado: $userid"
        fi
    done < "$fichero"

    echo ""
done

echo "=== Hecho. Usuarios y grupos creados en Proxmox. ==="
echo "Verifica con: pveum user list  /  pveum group list"
