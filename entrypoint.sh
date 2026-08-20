#!/bin/bash

NETBIOS_DOMAIN="${AD_NETBIOS_DOMAIN:-WIGITRON}"
AD_REALM="${AD_REALM:-WIGITRON.com}"
AD_ADMIN_PASSWORD="${AD_ADMIN_PASSWORD:-Admin!Test1234}"
LDAP_STRONG_AUTH="${LDAP_STRONG_AUTH:-no}"

if [ ! -f /var/lib/samba/private/sam.ldb ]; then
    echo "Provisioning new AD domain..."
    samba-tool domain provision \
        --domain="${NETBIOS_DOMAIN}" \
        --realm="${AD_REALM}" \
        --server-role=dc \
        --dns-backend=SAMBA_INTERNAL \
        --adminpass="${AD_ADMIN_PASSWORD}" \
        --use-rfc2307
    
    cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

    # Allow legacy applications to perform plaintext simple binds over port 389
    sed -i "/\\[global\\]/a \\        ldap server require strong auth = ${LDAP_STRONG_AUTH}" /etc/samba/smb.conf
fi

echo "Starting Samba AD DC..."
exec samba -i --debug-stdout
