#!/bin/bash
# Lista los usuarios del realm 'authentik' registrados en Proxmox VE con su grupo
# Ejecutar en el nodo Proxmox como root

set -euo pipefail

REALM="authentik"

echo "=== Usuarios del realm: $REALM ==="
echo ""

pveum user list --output-format json | python3 -c "
import sys, json

realm = '$REALM'
users = json.load(sys.stdin)
filtrados = [u for u in users if u.get('userid', '').endswith('@' + realm)]
filtrados.sort(key=lambda u: u['userid'])

print(f\"{'USUARIO':<45} {'GRUPOS'}\")
print(f\"{'-------':<45} {'------'}\")

for u in filtrados:
    userid = u['userid']
    grupos = u.get('groups', '-') or '-'
    print(f'{userid:<45} {grupos}')

print()
print(f'Total: {len(filtrados)}')
"
