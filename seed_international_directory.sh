#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SAMBA_CONTAINER="samba-dc-international" \
MAIL_DOMAIN="intl.wigitron.com" \
"${SCRIPT_DIR}/seed_directory.sh"
