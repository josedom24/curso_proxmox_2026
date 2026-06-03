#!/bin/bash
# Crea un pool por cada usuario del realm 'authentik' que pertenezca al grupo indicado
# y asigna las ACLs correspondientes (pool Imagenes, pools individuales y zona SDN)
# Cada pool incluye los almacenamientos: isos-hdd y ssd-vms
# Uso: ./crear_pools_acl.sh <grupo>
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

# --- Quitar ACL de administrador en / ---
echo "--- Eliminando ACL de administrador en / ---"

pvesh set /access/acl --path "/" --roles Administrator --groups "$GRUPO" --delete 1
echo "  [OK] $GRUPO -> Administrator -> / (eliminada)"

echo ""

echo "--- Pools para el grupo '$GRUPO' (realm: $REALM) ---"
echo ""

while IFS= read -r userid; do
    usuario_raw="${userid%@*}"
    usuario=$(echo "$usuario_raw" | tr '@.' '_')
    poolid="Proyecto_${usuario}"
    crear_pool "$poolid" "Pool de trabajo de $usuario_raw"
done <<< "$USUARIOS"

echo ""

# --- ACLs sobre pool Imagenes ---
echo "--- ACLs sobre pool Imagenes ---"

pveum acl modify /pool/Imagenes --roles template-clone --groups "$GRUPO"
echo "  [OK] $GRUPO -> template-clone -> /pool/Imagenes"

echo ""

# --- ACLs sobre pools individuales ---
echo "--- ACLs sobre pools individuales ---"

while IFS= read -r userid; do
    usuario_raw="${userid%@*}"
    usuario=$(echo "$usuario_raw" | tr '@.' '_')
    pveum acl modify /pool/Proyecto_"$usuario" --roles usuario --users "$userid"
    echo "  [OK] $userid -> usuario -> /pool/Proyecto_${usuario}"
done <<< "$USUARIOS"

echo ""

# --- ACLs sobre zona SDN ---
echo "--- ACLs sobre zona SDN localnetwork ---"

pveum acl modify /sdn/zones/localnetwork --roles red --groups "$GRUPO"
echo "  [OK] $GRUPO -> red -> /sdn/zones/localnetwork"

echo ""
echo "=== Hecho. Verifica con: pvesh get /pools  /  pveum acl list ==="
