#!/bin/bash

SAMBA_CONTAINER="${SAMBA_CONTAINER:-samba-dc}"
MAIL_DOMAIN="${MAIL_DOMAIN:-wigitron.com}"

echo "Creating Active Directory Groups..."
docker exec "${SAMBA_CONTAINER}" samba-tool group add "All_Engineering"
docker exec "${SAMBA_CONTAINER}" samba-tool group add "Dev_Team"
docker exec "${SAMBA_CONTAINER}" samba-tool group add "QA_Team"

echo "Nesting Child Groups into Parent Group..."
docker exec "${SAMBA_CONTAINER}" samba-tool group addmembers "All_Engineering" "Dev_Team"
docker exec "${SAMBA_CONTAINER}" samba-tool group addmembers "All_Engineering" "QA_Team"

echo "Creating and Assigning Mock Users..."
for i in {1..20}; do
  USERNAME="testuser${i}"
  PASSWORD="Password!${i}"
  
  docker exec "${SAMBA_CONTAINER}" samba-tool user add ${USERNAME} ${PASSWORD} \
    --given-name="Test" --surname="User${i}" --mail-address="${USERNAME}@${MAIL_DOMAIN}"
    
  if [ $i -le 10 ]; then
    docker exec "${SAMBA_CONTAINER}" samba-tool group addmembers "Dev_Team" "${USERNAME}"
  else
    docker exec "${SAMBA_CONTAINER}" samba-tool group addmembers "QA_Team" "${USERNAME}"
  fi
done

echo "Directory seeding complete!"
