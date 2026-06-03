#!/bin/bash
# Crea un pool por cada usuario del realm 'authentik' que pertenezca al grupo indicado
# Cada pool incluye los almacenamientos: isos-hdd y ssd-vms
# Uso: ./crear_pools.sh <grupo>
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

REALM="authentik"
STORAGES=("isos-hdd" "ssd-vms")

if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <grupo>"
    exit 1
fi

GRUPO="$1"

if ! pvesh get /access/groups/"$GRUPO" &>/dev/null; then
    echo "[ERROR] El grupo '$GRUPO' no existe en Proxmox."
    exit 1
fi

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

USUARIOS=$(pvesh get /access/groups/"$GRUPO" --output-format json \
    | grep -o '"[^"]*@'"$REALM"'"' \
    | tr -d '"' \
    | sort)

if [[ -z "$USUARIOS" ]]; then
    echo "[AVISO] No hay usuarios del realm '$REALM' en el grupo '$GRUPO'."
    exit 0
fi

echo "--- Pools para el grupo '$GRUPO' (realm: $REALM) ---"
echo ""

while IFS= read -r userid; do
    usuario="${userid%@*}"
    poolid="Proyecto_${usuario}"
    crear_pool "$poolid" "Pool de trabajo de $usuario"
done <<< "$USUARIOS"

echo ""
echo "=== Hecho. Verifica con: pvesh get /pools ==="
