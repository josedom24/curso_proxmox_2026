#!/bin/bash
# Lista los usuarios del realm 'authentik' registrados en Proxmox VE con su grupo
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

REALM="authentik"

echo "=== Usuarios del realm: $REALM ==="
echo ""
printf "%-45s %s\n" "USUARIO" "GRUPOS"
printf "%-45s %s\n" "-------" "------"

USUARIOS=$(pveum user list --output-format json \
    | grep -o '"userid":"[^"]*@'"$REALM"'"' \
    | grep -o '"[^"]*@'"$REALM"'"' \
    | tr -d '"' \
    | sort)

while IFS= read -r userid; do
    grupos=$(pvesh get /access/users/"$userid" --output-format json 2>/dev/null \
        | grep -o '"groups":"[^"]*"' \
        | sed 's/"groups":"//;s/"//' \
        || true)
    [[ -z "$grupos" ]] && grupos="-"
    printf "%-45s %s\n" "$userid" "$grupos"
done <<< "$USUARIOS"

echo ""
echo "Total: $(echo "$USUARIOS" | wc -l)"
