# Simulated-Active-Directory-LDAP-Test-Server

This repository includes a standalone international test domain alongside the existing `us.wigitron.com` environment.

## International domain artifacts

- `config/international.wigitron.com/setup.json` defines the separate `international.wigitron.com` domain, office sites, controllers, groups, users, and service accounts.
- `seed/international.wigitron.com/base.ldif` contains seed data for the new domain.
- `tests/test_international_domain.py` validates that the setup and LDIF seed stay aligned.

## Validation

Run:

`python -m unittest discover -s tests -p 'test_*.py'`
