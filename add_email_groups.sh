#!/bin/bash

echo "Creating Mail-Enabled Groups (Distribution Lists)..."

# Create the groups and assign the email address attribute
docker exec samba-dc samba-tool group add "All_Company" --mail-address="all@wigitron.local"
docker exec samba-dc samba-tool group add "Support_Team" --mail-address="support@wigitron.local"
docker exec samba-dc samba-tool group add "Marketing_Team" --mail-address="marketing@wigitron.local"

# Add all 20 existing test users to the 'All_Company' group
echo "Adding all users to All_Company (all@wigitron.local)..."
for i in {1..20}; do
  docker exec samba-dc samba-tool group addmembers "All_Company" "testuser${i}"
done

# Assign a subset of users to the Support group
echo "Assigning users 1-5 to Support_Team (support@wigitron.local)..."
for i in {1..5}; do
  docker exec samba-dc samba-tool group addmembers "Support_Team" "testuser${i}"
done

# Assign a different subset to the Marketing group
echo "Assigning users 6-10 to Marketing_Team (marketing@wigitron.local)..."
for i in {6..10}; do
  docker exec samba-dc samba-tool group addmembers "Marketing_Team" "testuser${i}"
done

echo "Email distribution groups created successfully!"
