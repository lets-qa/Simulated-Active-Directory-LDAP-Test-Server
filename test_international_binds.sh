#!/bin/bash

SAMBA_CONTAINER="samba-dc-international" \
LDAP_URI="ldap://localhost:1389" \
CONTAINER_LDAP_URI="ldap://127.0.0.1:389" \
UPN_DOMAIN="intl.wigitron.com" \
"/home/runner/work/Simulated-Active-Directory-LDAP-Test-Server/Simulated-Active-Directory-LDAP-Test-Server/test_binds.sh"
