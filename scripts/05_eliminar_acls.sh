#!/bin/bash
# Elimina las ACLs creadas por 04_crear_acls.sh
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REALM="pve"

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

# --- Zona SDN ---
echo "--- Eliminando ACLs de zona SDN localnetwork ---"

for grupo in smr asir profesores; do
    eliminar_acl_grupo /sdn/zones/localnetwork red "$grupo"
done

echo ""

# --- Pools individuales de cada usuario ---
echo "--- Eliminando ACLs de pools individuales ---"

for fichero in "$SCRIPT_DIR/smr.txt" "$SCRIPT_DIR/asir.txt" "$SCRIPT_DIR/profesores.txt"; do
    if [[ ! -f "$fichero" ]]; then
        echo "[ERROR] No se encuentra: $fichero"
        continue
    fi

    while IFS=',' read -r usuario password; do
        [[ -z "$usuario" || "$usuario" == \#* ]] && continue
        eliminar_acl_usuario /pool/Proyecto_"$usuario" usuario "${usuario}@${REALM}"
    done < "$fichero"
done

echo ""

# --- Pool Imagenes ---
echo "--- Eliminando ACLs de pool Imagenes ---"

eliminar_acl_grupo /pool/Imagenes template-create profesores
eliminar_acl_grupo /pool/Imagenes template-clone  profesores
eliminar_acl_grupo /pool/Imagenes template-clone  smr
eliminar_acl_grupo /pool/Imagenes template-clone  asir

echo ""
echo "=== Hecho. Verifica con: pveum acl list ==="
