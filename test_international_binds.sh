#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SAMBA_CONTAINER="samba-dc-international" \
LDAP_URI="ldap://localhost:1389" \
DOCKER_INTERNAL_LDAP_URI="ldap://127.0.0.1:389" \
UPN_DOMAIN="intl.wigitron.com" \
"${SCRIPT_DIR}/test_binds.sh"
