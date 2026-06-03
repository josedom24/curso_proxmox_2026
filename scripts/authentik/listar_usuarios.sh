#!/bin/bash
# Lista los usuarios del realm 'authentik' registrados en Proxmox VE
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

REALM="authentik"

echo "=== Usuarios del realm: $REALM ==="
echo ""

pveum user list --output-format json \
    | grep -o '"userid":"[^"]*@'"$REALM"'"' \
    | grep -o '"[^"]*@'"$REALM"'"' \
    | tr -d '"' \
    | sort

echo ""
echo "Total:"
pveum user list --output-format json \
    | grep -o '"userid":"[^"]*@'"$REALM"'"' \
    | wc -l
