from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User
from django.shortcuts import redirect, render
from django.views import View
import re
from rest_framework.authentication import SessionAuthentication
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from apps.employee.models import Employee
from apps.organization.models import Organization
from django.db import transaction


class LoginPageView(View):
    template_name = "authentication/login.html"

    def get(self, request):
        return render(
            request, self.template_name, {"next_url": request.GET.get("next", "/")}
        )

    def post(self, request):
        email = request.POST.get("email", "").strip()
        password = request.POST.get("password", "")
        next_url = request.POST.get("next", "/")

        if not email or not password:
            messages.error(request, "Email e senha sao obrigatorios.")
            return render(request, self.template_name, {"next_url": next_url})

        try:
            username = User.objects.get(email__iexact=email).username
        except User.DoesNotExist:
            username = email

        user = authenticate(request, username=username, password=password)
        if not user:
            messages.error(request, "Credenciais invalidas.")
            return render(request, self.template_name, {"next_url": next_url})

        login(request, user)
        return redirect(next_url or "/")


class RegisterView(APIView):
    permission_classes = [AllowAny]

    @transaction.atomic
    def post(self, request):
        username = _collapse_whitespace(request.data.get("username"))
        email = (request.data.get("email") or "").strip()
        password = request.data.get("password")
        role = _collapse_whitespace(request.data.get("role", ""))
        organization_id = request.data.get("organization_id")
        org_name = _collapse_whitespace(request.data.get("organization_name"))
        org_description = _collapse_whitespace(
            request.data.get("organization_description", "")
        )

        if not username or not password:
            return Response({"error": "username and password are required"}, status=400)

        if not organization_id and not org_name:
            return Response(
                {"error": "Please inform organization_id or organization_name"},
                status=400,
            )

        if User.objects.filter(username=username).exists():
            return Response({"error": "User already exists"}, status=400)

        if organization_id:
            try:
                organization = Organization.objects.get(id=organization_id)
            except Organization.DoesNotExist:
                return Response({"error": "Organization not found"}, status=404)
        else:
            organization = _find_organization_by_normalized_name(org_name)
            if organization and org_description and not organization.description:
                organization.description = org_description
                organization.save(update_fields=["description"])

            if not organization:
                organization = Organization.objects.create(
                    name=org_name, description=org_description
                )

        user = User.objects.create_user(
            username=username, email=email, password=password
        )

        employee = Employee.objects.create(
            name=username, e_mail=email, role=role, employee_organization=organization
        )

        return Response(
            {
                "user_id": user.id,
                "employee_id": employee.id,
                "organization_id": organization.id,
            },
            status=201,
        )


class LoginApiView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        email = (request.data.get("email") or "").strip()
        password = request.data.get("password") or ""

        if not email or not password:
            return Response({"error": "email and password are required"}, status=400)

        try:
            username = User.objects.get(email__iexact=email).username
        except User.DoesNotExist:
            username = email

        user = authenticate(request, username=username, password=password)
        if not user:
            return Response({"error": "Invalid credentials"}, status=401)

        login(request, user)

        # Identifica todas as empresas vinculadas ao e-mail do usuário.
        employees = Employee.objects.filter(e_mail__iexact=user.email).select_related(
            "employee_organization"
        )
        organizations = [
            {"id": e.employee_organization.id, "name": e.employee_organization.name}
            for e in employees
            if e.employee_organization
        ]

        return Response(
            {
                "id": user.id,
                "username": user.username,
                "full_name": user.get_full_name().strip() or user.username,
                "email": user.email,
                "is_admin": bool(user.is_staff or user.is_superuser),
                "organizations": organizations,
            },
            status=200,
        )


class ForgotPasswordApiView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        email = (request.data.get("email") or "").strip()
        if not email:
            return Response({"error": "email is required"}, status=400)

        # Sempre retorna 200 para evitar enumeracao de usuarios.
        return Response(
            {
                "message": "If the account exists, password recovery instructions were sent."
            },
            status=200,
        )


def _is_admin(user):
    return bool(user and user.is_authenticated and (user.is_staff or user.is_superuser))


def _collapse_whitespace(value):
    return re.sub(r"\s+", " ", (value or "").strip())


def _normalize_organization_name(value):
    return _collapse_whitespace(value).casefold()


def _find_organization_by_normalized_name(name):
    normalized_name = _normalize_organization_name(name)
    if not normalized_name:
        return None

    for organization in Organization.objects.only("id", "name", "description"):
        if _normalize_organization_name(organization.name) == normalized_name:
            return organization
    return None


def _has_membership(user, organization_id):
    if not user or not user.is_authenticated or not user.email or not organization_id:
        return False

    return Employee.objects.filter(
        e_mail__iexact=user.email,
        employee_organization_id=organization_id,
    ).exists()


class OrganizationSettingsApiView(APIView):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        organization_id = request.query_params.get("organization_id")

        if not organization_id:
            return Response({"error": "organization_id is required"}, status=400)

        try:
            organization = Organization.objects.get(id=organization_id)
        except Organization.DoesNotExist:
            return Response({"error": "Organization not found"}, status=404)

        if not (
            _is_admin(request.user) or _has_membership(request.user, organization.id)
        ):
            return Response(
                {"error": "You do not have access to this organization."},
                status=403,
            )

        current_email = (request.user.email or "").strip().lower()
        is_admin = _is_admin(request.user)
        members = Employee.objects.filter(employee_organization=organization).order_by(
            "name", "id"
        )
        current_membership = Employee.objects.filter(
            e_mail__iexact=request.user.email,
            employee_organization=organization,
        ).first()

        return Response(
            {
                "organization": {
                    "id": organization.id,
                    "name": organization.name,
                    "description": organization.description or "",
                    "member_count": members.count(),
                },
                "current_user": {
                    "full_name": request.user.get_full_name().strip()
                    or request.user.username,
                    "first_name": request.user.first_name or "",
                    "last_name": request.user.last_name or "",
                    "username": request.user.username,
                    "email": request.user.email,
                    "is_admin": is_admin,
                    "role": getattr(current_membership, "role", "") or "",
                },
                "members": [
                    {
                        "id": member.id,
                        "name": member.name or member.e_mail or f"Member {member.id}",
                        "email": member.e_mail or "",
                        "role": member.role or "",
                        "is_current_user": bool(
                            current_email
                            and member.e_mail
                            and member.e_mail.strip().lower() == current_email
                        ),
                        "can_delete": bool(
                            is_admin
                            or (
                                current_email
                                and member.e_mail
                                and member.e_mail.strip().lower() == current_email
                            )
                        ),
                    }
                    for member in members
                ],
            },
            status=200,
        )


class OrganizationSettingsMemberApiView(APIView):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsAuthenticated]

    @transaction.atomic
    def delete(self, request, member_id):
        try:
            member = Employee.objects.select_related("employee_organization").get(
                id=member_id
            )
        except Employee.DoesNotExist:
            return Response({"error": "Member not found"}, status=404)

        current_email = (request.user.email or "").strip().lower()
        member_email = (member.e_mail or "").strip().lower()
        same_user = bool(
            current_email and member_email and current_email == member_email
        )
        is_admin = _is_admin(request.user)

        if not is_admin:
            if not member.employee_organization_id or not _has_membership(
                request.user, member.employee_organization_id
            ):
                return Response(
                    {"error": "You do not have access to this organization."},
                    status=403,
                )

            if not same_user:
                return Response(
                    {"error": "Only admins can remove other users."},
                    status=403,
                )

        deleted_payload = {
            "id": member.id,
            "organization_id": member.employee_organization_id,
            "deleted_self": same_user,
        }
        member.delete()
        return Response(deleted_payload, status=200)


class CurrentUserProfileApiView(APIView):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsAuthenticated]

    @transaction.atomic
    def patch(self, request):
        first_name = (request.data.get("first_name") or "").strip()
        last_name = (request.data.get("last_name") or "").strip()

        if not first_name and not last_name:
            return Response(
                {"error": "Provide at least first_name or last_name."},
                status=400,
            )

        request.user.first_name = first_name
        request.user.last_name = last_name
        request.user.save(update_fields=["first_name", "last_name"])

        full_name = request.user.get_full_name().strip() or request.user.username
        if request.user.email:
            Employee.objects.filter(e_mail__iexact=request.user.email).update(
                name=full_name
            )

        return Response(
            {
                "username": request.user.username,
                "email": request.user.email,
                "first_name": request.user.first_name,
                "last_name": request.user.last_name,
                "full_name": full_name,
            },
            status=200,
        )
