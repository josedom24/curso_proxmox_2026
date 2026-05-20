#!/bin/bash
# Elimina los pools creados por 03_crear_pools.sh
# Antes de borrar cada pool, elimina sus recursos (storages y VMs asignadas)
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
FICHEROS=("$SCRIPT_DIR/smr.txt" "$SCRIPT_DIR/asir.txt" "$SCRIPT_DIR/profesores.txt")
STORAGES=("isos-hdd" "ssd-vms")

vaciar_pool() {
    local poolid="$1"

    # Quitar storages conocidos
    for storage in "${STORAGES[@]}"; do
        pvesh set /pools/"$poolid" --storage "$storage" --delete 1 2>/dev/null \
            && echo "    [OK] Storage quitado: $storage" \
            || true
    done

    # Quitar VMs/CTs que pueda tener asignadas (sin borrarlas)
    local vmids
    vmids=$(pvesh get /pools/"$poolid" --output-format json 2>/dev/null \
        | grep -o '"vmid":[0-9]*' | grep -o '[0-9]*')

    if [[ -n "$vmids" ]]; then
        while IFS= read -r vmid; do
            pvesh set /pools/"$poolid" --vms "$vmid" --delete 1 2>/dev/null \
                && echo "    [OK] VM $vmid quitada del pool" \
                || true
        done <<< "$vmids"
    fi
}

eliminar_pool() {
    local poolid="$1"

    if pvesh get /pools/"$poolid" &>/dev/null; then
        echo "  Vaciando pool: $poolid"
        vaciar_pool "$poolid"
        pvesh delete /pools/"$poolid"
        echo "  [OK] Pool eliminado: $poolid"
    else
        echo "  [NO EXISTE] Pool: $poolid"
    fi
}

# Pools de usuarios
for fichero in "${FICHEROS[@]}"; do
    if [[ ! -f "$fichero" ]]; then
        echo "[ERROR] No se encuentra el fichero: $fichero"
        continue
    fi

    echo "--- Eliminando pools de: $(basename "$fichero") ---"

    while IFS=',' read -r usuario password; do
        [[ -z "$usuario" || "$usuario" == \#* ]] && continue
        eliminar_pool "Proyecto_${usuario}"
    done < "$fichero"

    echo ""
done

# Pool de imágenes
echo "--- Pool de imágenes ---"
eliminar_pool "Imagenes"

echo ""
echo "=== Hecho. Verifica con: pvesh get /pools ==="
