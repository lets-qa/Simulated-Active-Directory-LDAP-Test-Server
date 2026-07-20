#!/bin/bash

LDAP_URI="ldap://localhost:389"
DOMAIN="wigitron.local"

test_bind() {
  local upn=$1
  local pass=$2
  
  if ldapwhoami -H "$LDAP_URI" -x -D "$upn" -w "$pass" > /dev/null 2>&1; then
    echo "✅ [SUCCESS] Bind accepted for: $upn"
  else
    echo "❌ [FAILED]  Bind rejected for: $upn"
  fi
}

echo "Testing valid credentials..."
for i in {1..5}; test_bind "testuser${i}@${DOMAIN}" "Password!${i}"; done

echo -e "\nTesting invalid password behavior..."
test_bind "testuser1@${DOMAIN}" "WrongPassword123!"

echo -e "\nTesting non-existent user behavior..."
test_bind "ghostuser@${DOMAIN}" "Password!1"
