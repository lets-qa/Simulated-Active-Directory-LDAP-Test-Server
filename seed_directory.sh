#!/bin/bash

echo "Creating Active Directory Groups..."
docker exec samba-dc samba-tool group add "All_Engineering"
docker exec samba-dc samba-tool group add "Dev_Team"
docker exec samba-dc samba-tool group add "QA_Team"

echo "Nesting Child Groups into Parent Group..."
docker exec samba-dc samba-tool group addmembers "All_Engineering" "Dev_Team"
docker exec samba-dc samba-tool group addmembers "All_Engineering" "QA_Team"

echo "Creating and Assigning Mock Users..."
for i in {1..20}; do
  USERNAME="testuser${i}"
  PASSWORD="Password!${i}"
  
  docker exec samba-dc samba-tool user add ${USERNAME} ${PASSWORD} \
    --given-name="Test" --surname="User${i}" --mail-address="${USERNAME}@wigitron.local"
    
  if [ $i -le 10 ]; then
    docker exec samba-dc samba-tool group addmembers "Dev_Team" "${USERNAME}"
  else
    docker exec samba-dc samba-tool group addmembers "QA_Team" "${USERNAME}"
  fi
done

echo "Directory seeding complete!"
