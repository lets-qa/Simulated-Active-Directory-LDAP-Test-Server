#!/bin/bash

LDAP_URI="ldap://localhost:389"
DOMAIN="WIGITRON"

test_bind() {
  local user=$1
  local pass=$2
  
  # Bind using the classic AD NetBIOS format: DOMAIN\username
  if ldapwhoami -H "$LDAP_URI" -x -D "${DOMAIN}\\${user}" -w "$pass" > /dev/null 2>&1; then
    echo "✅ [SUCCESS] Bind accepted for: ${DOMAIN}\\${user}"
  else
    echo "❌ [FAILED]  Bind rejected for: ${DOMAIN}\\${user}"
  fi
}

echo "Testing valid credentials..."
for i in {1..5}; do test_bind "testuser${i}" "Password!${i}"; done

echo -e "\nTesting invalid password behavior..."
test_bind "testuser1" "WrongPassword123!"

echo -e "\nTesting non-existent user behavior..."
test_bind "ghostuser" "Password!1"
