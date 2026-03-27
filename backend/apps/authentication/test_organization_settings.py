from django.contrib.auth.models import User
from django.test import TestCase

from apps.employee.models import Employee
from apps.organization.models import Organization


class OrganizationSettingsApiTests(TestCase):
    def setUp(self):
        self.organization = Organization.objects.create(name="Atlas Retail")
        self.other_organization = Organization.objects.create(name="Beacon Health")

        self.member_user = User.objects.create_user(
            username="member",
            email="member@example.com",
            password="test-pass-123",
        )
        self.admin_user = User.objects.create_user(
            username="admin",
            email="admin@example.com",
            password="test-pass-123",
            is_staff=True,
        )

        self.member_employee = Employee.objects.create(
            name="Member User",
            e_mail="member@example.com",
            role="Engineer",
            employee_organization=self.organization,
        )
        self.other_employee = Employee.objects.create(
            name="Other User",
            e_mail="other@example.com",
            role="Developer",
            employee_organization=self.organization,
        )
        self.remote_employee = Employee.objects.create(
            name="Remote User",
            e_mail="remote@example.com",
            role="Developer",
            employee_organization=self.other_organization,
        )

    def test_member_can_list_current_organization_settings(self):
        self.client.force_login(self.member_user)

        response = self.client.get(
            "/auth/organization-settings/",
            {"organization_id": self.organization.id},
        )

        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["organization"]["id"], self.organization.id)
        self.assertEqual(payload["current_user"]["email"], "member@example.com")
        self.assertFalse(payload["current_user"]["is_admin"])
        self.assertEqual(len(payload["members"]), 2)
        current_member = next(
            item for item in payload["members"] if item["id"] == self.member_employee.id
        )
        other_member = next(
            item for item in payload["members"] if item["id"] == self.other_employee.id
        )
        self.assertTrue(current_member["is_current_user"])
        self.assertTrue(current_member["can_delete"])
        self.assertFalse(other_member["can_delete"])

    def test_member_can_delete_self_membership(self):
        self.client.force_login(self.member_user)

        response = self.client.delete(
            f"/auth/organization-settings/members/{self.member_employee.id}/"
        )

        self.assertEqual(response.status_code, 200)
        self.assertFalse(Employee.objects.filter(id=self.member_employee.id).exists())
        self.assertTrue(response.json()["deleted_self"])

    def test_member_cannot_delete_other_member(self):
        self.client.force_login(self.member_user)

        response = self.client.delete(
            f"/auth/organization-settings/members/{self.other_employee.id}/"
        )

        self.assertEqual(response.status_code, 403)
        self.assertTrue(Employee.objects.filter(id=self.other_employee.id).exists())

    def test_admin_can_delete_other_member(self):
        self.client.force_login(self.admin_user)

        response = self.client.delete(
            f"/auth/organization-settings/members/{self.other_employee.id}/"
        )

        self.assertEqual(response.status_code, 200)
        self.assertFalse(Employee.objects.filter(id=self.other_employee.id).exists())
        self.assertFalse(response.json()["deleted_self"])

    def test_member_cannot_access_unrelated_organization(self):
        self.client.force_login(self.member_user)

        response = self.client.get(
            "/auth/organization-settings/",
            {"organization_id": self.other_organization.id},
        )

        self.assertEqual(response.status_code, 403)
        self.assertTrue(Employee.objects.filter(id=self.remote_employee.id).exists())

    def test_member_can_update_own_profile_name(self):
        self.client.force_login(self.member_user)

        response = self.client.patch(
            "/auth/profile/",
            data={"first_name": "Alexandre", "last_name": "Seixas"},
            content_type="application/json",
        )

        self.assertEqual(response.status_code, 200)
        self.member_user.refresh_from_db()
        self.assertEqual(self.member_user.first_name, "Alexandre")
        self.assertEqual(self.member_user.last_name, "Seixas")
        self.member_employee.refresh_from_db()
        self.assertEqual(self.member_employee.name, "Alexandre Seixas")

    def test_profile_update_requires_at_least_one_name_field(self):
        self.client.force_login(self.member_user)

        response = self.client.patch(
            "/auth/profile/",
            data={"first_name": "", "last_name": ""},
            content_type="application/json",
        )

        self.assertEqual(response.status_code, 400)
