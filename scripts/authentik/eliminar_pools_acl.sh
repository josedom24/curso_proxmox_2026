#!/bin/bash
# Elimina los pools y ACLs creados por crear_pools_acl.sh para el grupo indicado
# Uso: ./eliminar_pools_acl.sh <grupo>
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

USUARIOS=$(pvesh get /access/groups/"$GRUPO" --output-format json \
    | grep -o '"[^"]*@'"$REALM"'"' \
    | tr -d '"' \
    | sort)

if [[ -z "$USUARIOS" ]]; then
    echo "[AVISO] No hay usuarios del realm '$REALM' en el grupo '$GRUPO'."
    exit 0
fi

eliminar_acl_grupo() {
    local path="$1" rol="$2" grupo="$3"
    pvesh set /access/acl --path "$path" --roles "$rol" --groups "$grupo" --delete 1
    echo "  [OK] $grupo -> $rol -> $path"
}

eliminar_acl_usuario() {
    local path="$1" rol="$2" usuario="$3"
    pvesh set /access/acl --path "$path" --roles "$rol" --users "$usuario" --delete 1
    echo "  [OK] $usuario -> $rol -> $path"
}

vaciar_pool() {
    local poolid="$1"

    for storage in "${STORAGES[@]}"; do
        pvesh set /pools/"$poolid" --storage "$storage" --delete 1 2>/dev/null \
            && echo "    [OK] Storage quitado: $storage" \
            || true
    done

    local vmids
    vmids=$(pvesh get /pools/"$poolid" --output-format json 2>/dev/null \
        | grep -o '"vmid":[0-9]*' | grep -o '[0-9]*' || true)

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

# --- ACLs zona SDN ---
echo "--- Eliminando ACLs de zona SDN localnetwork ---"

eliminar_acl_grupo /sdn/zones/localnetwork red "$GRUPO"

echo ""

# --- ACLs pools individuales ---
echo "--- Eliminando ACLs de pools individuales ---"

while IFS= read -r userid; do
    usuario_raw="${userid%@*}"
    usuario=$(echo "$usuario_raw" | tr '@.' '_')
    eliminar_acl_usuario /pool/Proyecto_"$usuario" usuario "$userid"
done <<< "$USUARIOS"

echo ""

# --- ACLs pool Imagenes ---
echo "--- Eliminando ACLs de pool Imagenes ---"

eliminar_acl_grupo /pool/Imagenes template-clone "$GRUPO"

echo ""

# --- Eliminar pools individuales ---
echo "--- Eliminando pools individuales ---"

while IFS= read -r userid; do
    usuario_raw="${userid%@*}"
    usuario=$(echo "$usuario_raw" | tr '@.' '_')
    eliminar_pool "Proyecto_${usuario}"
done <<< "$USUARIOS"

echo ""
echo "=== Hecho. Verifica con: pvesh get /pools  /  pveum acl list ==="
