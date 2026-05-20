#!/bin/bash
# Elimina las ACLs creadas por crear_acls.sh
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REALM="pve"

# --- Zona SDN ---
echo "--- Eliminando ACLs de zona SDN localnetwork ---"

for grupo in smr asir profesores; do
    pveum acl modify /sdn/zones/localnetwork --roles red --groups "$grupo" --delete 1
    echo "  [OK] $grupo -> red -> /sdn/zones/localnetwork"
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
        pveum acl modify /pool/Proyecto_"$usuario" --roles usuario --users "${usuario}@${REALM}" --delete 1
        echo "  [OK] ${usuario}@${REALM} -> usuario -> /pool/Proyecto_${usuario}"
    done < "$fichero"
done

echo ""

# --- Pool Imagenes ---
echo "--- Eliminando ACLs de pool Imagenes ---"

pveum acl modify /pool/Imagenes --roles template-create --groups profesores --delete 1
echo "  [OK] profesores -> template-create -> /pool/Imagenes"

pveum acl modify /pool/Imagenes --roles template-clone --groups profesores --delete 1
echo "  [OK] profesores -> template-clone  -> /pool/Imagenes"

pveum acl modify /pool/Imagenes --roles template-clone --groups smr --delete 1
echo "  [OK] smr        -> template-clone  -> /pool/Imagenes"

pveum acl modify /pool/Imagenes --roles template-clone --groups asir --delete 1
echo "  [OK] asir       -> template-clone  -> /pool/Imagenes"

echo ""
echo "=== Hecho. Verifica con: pveum acl list ==="
