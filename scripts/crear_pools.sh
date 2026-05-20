#!/bin/bash
# Crea el pool de Imagenes y un pool por cada alumno en Proxmox VE
# Cada pool incluye los almacenamientos: isos-hdd y ssd-vms
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STORAGES=("isos-hdd" "ssd-vms")
FICHEROS=("$SCRIPT_DIR/smr.txt" "$SCRIPT_DIR/asir.txt" "$SCRIPT_DIR/profesores.txt")

crear_pool() {
    local poolid="$1"
    local comment="$2"

    if pvesh get /pools/"$poolid" &>/dev/null; then
        echo "  [YA EXISTE] Pool: $poolid"
    else
        pvesh create /pools --poolid "$poolid" --comment "$comment"
        echo "  [OK] Pool creado: $poolid"
    fi

    for storage in "${STORAGES[@]}"; do
        pvesh set /pools/"$poolid" --storage "$storage" 2>/dev/null \
            && echo "  [OK]   Storage añadido: $storage -> $poolid" \
            || echo "  [AVISO] No se pudo añadir storage $storage a $poolid"
    done
}

# Pool centralizado de plantillas
echo "--- Pool de imágenes ---"
crear_pool "Imagenes" "Pool de plantillas del centro"
echo ""

# Un pool por cada alumno
for fichero in "${FICHEROS[@]}"; do
    if [[ ! -f "$fichero" ]]; then
        echo "[ERROR] No se encuentra el fichero: $fichero"
        continue
    fi

    echo "--- Pools de alumnos: $(basename "$fichero") ---"

    while IFS=',' read -r usuario password; do
        [[ -z "$usuario" || "$usuario" == \#* ]] && continue
        poolid="Proyecto_${usuario}"
        crear_pool "$poolid" "Pool de trabajo de $usuario"
    done < "$fichero"

    echo ""
done

echo "=== Hecho. Verifica con: pvesh get /pools ==="
