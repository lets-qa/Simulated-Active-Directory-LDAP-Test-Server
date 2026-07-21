# Wigitron Active Directory LDAP Mock Environment

This repository provides a fully functional, containerized Active Directory LDAP simulator based on Samba. It is designed for testing legacy applications that rely on Microsoft AD specific schemas (like `sAMAccountName`, `userPrincipalName`, and nested groups).

## Included Files

- `docker-compose.yml`: Defines the Samba container, port mappings, and persistent volumes.
- `Dockerfile`: Builds the Ubuntu-based image and installs necessary Samba and LDAP utilities.
- `entrypoint.sh`: Provisions the `WIGITRON.COM` domain upon first boot and starts the Samba daemon.
- `seed_directory.sh`: A helper script that executes inside the running container to create nested organizational groups (`All_Engineering`, `Dev_Team`, `QA_Team`) and populates them with 20 mock users.
- `add_email_groups.sh`: An add-on script to create shared distribution lists (e.g., `all@wigitron.com`, `support@wigitron.com`) and map them to mock users.
- `test_binds.sh`: A host-side script to verify that LDAP authentication (binds) is functioning correctly using `ldapwhoami`.

## Prerequisites

- Docker and Docker Compose installed on your host machine.
- Optional: `ldap-utils` installed on your host if you wish to run the `test_binds.sh` and email queries locally.

## Deployment Instructions

Follow these steps to build the image, provision the domain, and inject the mock data.

### 1. Make Scripts Executable
Before building the container, ensure the helper scripts have execution permissions.
    
    chmod +x entrypoint.sh seed_directory.sh add_email_groups.sh test_binds.sh

### 2. Build and Start the Environment
Launch the environment in detached mode. The initial build will take a moment as it downloads Ubuntu and installs the packages. Once running, the `entrypoint.sh` script will automatically provision the domain structure.
    
    docker compose up -d --build

*Note: Give the container about 10-15 seconds after starting for the Samba daemon to fully initialize.*

### 3. Inject the Test Data
Once the container is healthy, run the seeding scripts from your host machine. 

First, rapidly build the organizational nested groups and populate the 20 test users (`testuser1` to `testuser20` with passwords `Password!1` to `Password!20`):
    
    ./seed_directory.sh

Next, create the shared email distribution lists and map the existing users to them:

    ./add_email_groups.sh

### 4. Verify Authentication
Run the bind testing script to confirm the directory is accepting credentials. This script will attempt 5 successful logins and 2 deliberate failures to ensure the directory is enforcing authentication properly.
    
    ./test_binds.sh

### 5. Verify Email Group Routing
If you are testing mail servers or applications that need to resolve distribution lists, you can verify the LDAP mapping by querying the directory for the members of a shared email address. 

Run this command to ask the directory for everyone assigned to the support email:

    ldapsearch -H ldap://localhost:389 \
      -D "cn=Administrator,cn=Users,dc=wigitron,dc=com" \
      -w 'Admin!Test1234' \
      -b "dc=wigitron,dc=com" \
      "(mail=support@wigitron.com)" \
      member

*The output should cleanly list the distinguished names (DN) of test users 1 through 5.*

## Stopping and Resetting

**To stop the environment (while keeping your data):**
    
    docker compose down

**To completely wipe the environment (destroying all test users and the domain):**
    
    docker compose down -v

*Running `docker compose up -d` after wiping the volumes will trigger a fresh domain provision.*

## Connection Details

Legacy applications can connect to this environment using the following parameters:

- **LDAP URI:** `ldap://localhost:389` (or the Docker host's IP)
- **LDAPS URI:** `ldaps://localhost:636` *(Self-signed certificate)*
- **Domain:** `wigitron.com`
- **Base DN:** `dc=wigitron,dc=com`
- **Bind Credentials (UPN):** `testuser1@wigitron.com`
- **Bind Credentials (DN):** `cn=Administrator,cn=Users,dc=wigitron,dc=com`
- **Administrator Password:** `Admin!Test1234`
