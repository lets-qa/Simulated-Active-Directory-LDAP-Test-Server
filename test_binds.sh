#!/bin/bash

LDAP_URI="${LDAP_URI:-ldap://localhost:389}"
DOCKER_INTERNAL_LDAP_URI="${DOCKER_INTERNAL_LDAP_URI:-ldap://127.0.0.1:389}"
SAMBA_CONTAINER="${SAMBA_CONTAINER:-samba-dc}"
UPN_DOMAIN="${UPN_DOMAIN:-wigitron.com}"

test_bind() {
  local user=$1
  local pass=$2
  
  if command -v ldapwhoami > /dev/null 2>&1; then
    ldapwhoami -H "$LDAP_URI" -x -D "${user}@${UPN_DOMAIN}" -w "$pass" > /dev/null 2>&1
  else
    docker exec "${SAMBA_CONTAINER}" ldapwhoami -H "${DOCKER_INTERNAL_LDAP_URI}" -x -D "${user}@${UPN_DOMAIN}" -w "$pass" > /dev/null 2>&1
  fi
  bind_status=$?

  if [ "${bind_status}" -eq 0 ]; then
    echo "✅ [SUCCESS] Bind accepted for: ${user}@${UPN_DOMAIN}"
  else
    echo "❌ [FAILED]  Bind rejected for: ${user}@${UPN_DOMAIN}"
  fi
}

echo "Testing valid credentials..."
for i in {1..5}; do test_bind "testuser${i}" "Password!${i}"; done

echo -e "\nTesting invalid password behavior..."
test_bind "testuser1" "WrongPassword123!"

echo -e "\nTesting non-existent user behavior..."
test_bind "ghostuser" "Password!1"
