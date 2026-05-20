#!/bin/bash
# Asigna las ACLs en Proxmox VE
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REALM="pve"

# --- Pool Imagenes ---
echo "--- ACLs sobre pool Imagenes ---"

# Profesores: pueden crear y clonar plantillas
pveum acl modify /pool/Imagenes --roles template-create --groups profesores
echo "  [OK] profesores -> template-create -> /pool/Imagenes"

pveum acl modify /pool/Imagenes --roles template-clone --groups profesores
echo "  [OK] profesores -> template-clone  -> /pool/Imagenes"

# Alumnos: solo pueden clonar plantillas
pveum acl modify /pool/Imagenes --roles template-clone --groups smr
echo "  [OK] smr        -> template-clone  -> /pool/Imagenes"

pveum acl modify /pool/Imagenes --roles template-clone --groups asir
echo "  [OK] asir       -> template-clone  -> /pool/Imagenes"

echo ""

# --- Pools individuales de cada usuario ---
echo "--- ACLs sobre pools individuales ---"

for fichero in "$SCRIPT_DIR/smr.txt" "$SCRIPT_DIR/asir.txt" "$SCRIPT_DIR/profesores.txt"; do
    if [[ ! -f "$fichero" ]]; then
        echo "[ERROR] No se encuentra: $fichero"
        continue
    fi

    while IFS=',' read -r usuario password; do
        [[ -z "$usuario" || "$usuario" == \#* ]] && continue
        pveum acl modify /pool/Proyecto_"$usuario" --roles usuario --users "${usuario}@${REALM}"
        echo "  [OK] ${usuario}@${REALM} -> usuario -> /pool/Proyecto_${usuario}"
    done < "$fichero"
done

echo ""

# --- Zona SDN ---
echo "--- ACLs sobre zona SDN localnetwork ---"

for grupo in smr asir profesores; do
    pveum acl modify /sdn/zones/localnetwork --roles red --groups "$grupo"
    echo "  [OK] $grupo -> red -> /sdn/zones/localnetwork"
done

echo ""
echo "=== Hecho. Verifica con: pveum acl list ==="
