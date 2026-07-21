import json
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
SETUP_PATH = REPO_ROOT / "config" / "international.wigitron.com" / "setup.json"
SEED_PATH = REPO_ROOT / "seed" / "international.wigitron.com" / "base.ldif"


class InternationalDomainConfigurationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.setup = json.loads(SETUP_PATH.read_text())
        cls.seed = SEED_PATH.read_text()

    def test_domain_is_separate_from_us_domain(self):
        self.assertEqual(self.setup["domainName"], "international.wigitron.com")
        self.assertEqual(
            self.setup["topology"]["isolatedFrom"],
            "us.wigitron.com",
        )
        self.assertEqual(
            self.setup["distinguishedName"],
            "DC=international,DC=wigitron,DC=com",
        )

    def test_seed_contains_expected_domain_root(self):
        self.assertIn("dn: DC=international,DC=wigitron,DC=com", self.seed)
        self.assertNotIn("DC=us,DC=wigitron,DC=com", self.seed)

    def test_every_site_has_a_matching_office_ou(self):
        for site in self.setup["sites"]:
            self.assertIn(
                f"dn: OU={site['name']},OU=Offices,DC=international,DC=wigitron,DC=com",
                self.seed,
            )

    def test_every_group_member_exists_in_seed_data(self):
        for group in self.setup["groups"]:
            for member in group["members"]:
                self.assertIn(f"member: {member}", self.seed)
                self.assertIn(f"dn: {member}", self.seed)

    def test_domain_controllers_are_seeded_as_computers(self):
        for controller in self.setup["domainControllers"]:
            hostname = controller["hostname"]
            self.assertIn(
                f"dn: CN={hostname},OU=Servers,DC=international,DC=wigitron,DC=com",
                self.seed,
            )
            self.assertIn(
                f"dNSHostName: {hostname}.international.wigitron.com",
                self.seed,
            )


if __name__ == "__main__":
    unittest.main()
