#!/bin/bash
# Elimina los pools creados por crear_pools.sh
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
FICHEROS=("$SCRIPT_DIR/smr.txt" "$SCRIPT_DIR/asir.txt" "$SCRIPT_DIR/profesores.txt")

eliminar_pool() {
    local poolid="$1"

    if pvesh get /pools/"$poolid" &>/dev/null; then
        pvesh delete /pools/"$poolid"
        echo "  [OK] Pool eliminado: $poolid"
    else
        echo "  [NO EXISTE] Pool: $poolid"
    fi
}

# Pools de alumnos
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
