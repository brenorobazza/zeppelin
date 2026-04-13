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
from apps.organization.models import (
    Organization,
    OrganizationCategory,
    OrganizationType,
    Size,
    State,
)
from django.db import transaction
from oauth2_provider.models import Application, AccessToken, RefreshToken
from oauthlib.common import generate_token
from django.utils import timezone
from datetime import timedelta
from django.conf import settings


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

    YEARS_TO_AGE = {
        "Less than 1 year": 1,
        "1-3 years": 2,
        "4-7 years": 5,
        "8-12 years": 10,
        "More than 12 years": 13,
    }

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
        years = _collapse_whitespace(request.data.get("years", ""))
        state_name = _collapse_whitespace(request.data.get("state", ""))
        organization_type_name = _collapse_whitespace(
            request.data.get("organization_type", "")
        )
        organization_sector = _collapse_whitespace(
            request.data.get("organization_sector", "")
        )
        organization_size_name = _collapse_whitespace(
            request.data.get("organization_size", "")
        )
        target_audience = _collapse_whitespace(request.data.get("target_audience", ""))

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

                fields_to_update = []

                if years:
                    organization.years_experience_range = years
                    organization.age = self.YEARS_TO_AGE.get(years)
                    fields_to_update.extend(["years_experience_range", "age"])

                if state_name:
                    state, _ = State.objects.get_or_create(name=state_name)
                    organization.location = state
                    fields_to_update.append("location")

                if organization_size_name:
                    size, _ = Size.objects.get_or_create(name=organization_size_name)
                    organization.organization_size = size
                    fields_to_update.append("organization_size")

                if organization_type_name:
                    category = None
                    if organization_sector:
                        category, _ = OrganizationCategory.objects.get_or_create(
                            name=organization_sector
                        )

                    defaults = {
                        "description": organization_type_name,
                        "category_organization_type": category,
                    }
                    organization_type, _ = OrganizationType.objects.get_or_create(
                        name=organization_type_name,
                        defaults=defaults,
                    )

                    if (
                        category
                        and organization_type.category_organization_type_id
                        != category.id
                    ):
                        organization_type.category_organization_type = category
                        organization_type.save(
                            update_fields=["category_organization_type"]
                        )

                    organization.organization_type = organization_type
                    fields_to_update.append("organization_type")

                if organization_sector:
                    organization.organization_sector = organization_sector
                    fields_to_update.append("organization_sector")

                if target_audience:
                    organization.target_audience = target_audience
                    fields_to_update.append("target_audience")

                if fields_to_update:
                    organization.save(update_fields=fields_to_update)

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

        # Generate OAuth2 Token
        app = Application.objects.filter(
            client_type=Application.CLIENT_CONFIDENTIAL
        ).first()
        if not app:
            app = Application.objects.first()

        access_token_str = None
        refresh_token_str = None
        expires_in = getattr(settings, "OAUTH2_PROVIDER", {}).get(
            "ACCESS_TOKEN_EXPIRE_SECONDS", 36000
        )

        if app:
            access_token_str = generate_token()
            refresh_token_str = generate_token()
            expires = timezone.now() + timedelta(seconds=expires_in)

            AccessToken.objects.create(
                user=user,
                application=app,
                expires=expires,
                token=access_token_str,
                scope="read write",
            )

            RefreshToken.objects.create(
                user=user,
                application=app,
                token=refresh_token_str,
                access_token=AccessToken.objects.get(token=access_token_str),
            )

        # Identifica todas as empresas vinculadas ao e-mail do usuário.
        employees = Employee.objects.filter(e_mail__iexact=user.email).select_related(
            "employee_organization"
        )
        organizations = [
            {"id": e.employee_organization.id, "name": e.employee_organization.name}
            for e in employees
            if e.employee_organization
        ]

        response_data = {
            "id": user.id,
            "username": user.username,
            "full_name": user.get_full_name().strip() or user.username,
            "email": user.email,
            "is_admin": bool(user.is_staff or user.is_superuser),
            "organizations": organizations,
        }

        if access_token_str:
            response_data["access_token"] = access_token_str
            response_data["refresh_token"] = refresh_token_str
            response_data["expires_in"] = expires_in

        return Response(response_data, status=200)


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
