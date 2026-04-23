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
from apps.authentication.models import UserOrganizationPreference


YEARS_TO_AGE = {
    "Less than 1 year": 1,
    "1-3 years": 2,
    "4-7 years": 5,
    "8-12 years": 10,
    "More than 12 years": 13,
}


def _resolve_age_from_years(years):
    if not years:
        return None

    mapped_age = YEARS_TO_AGE.get(years)
    if mapped_age is not None:
        return mapped_age

    try:
        parsed_years = int(years)
    except (TypeError, ValueError):
        return None

    return parsed_years if parsed_years >= 0 else None


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
        organization_country = _collapse_whitespace(
            request.data.get("organization_country", "")
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

        if User.objects.filter(username=username).exists():
            return Response({"error": "User already exists"}, status=400)

        organization = None
        if organization_id or org_name:
            try:
                organization = _resolve_or_create_organization(
                    organization_id=organization_id,
                    org_name=org_name,
                    org_description=org_description,
                    organization_country=organization_country,
                    years=years,
                    state_name=state_name,
                    organization_type_name=organization_type_name,
                    organization_sector=organization_sector,
                    organization_size_name=organization_size_name,
                    target_audience=target_audience,
                )
            except ValueError as exc:
                return Response({"error": str(exc)}, status=400)
            except Organization.DoesNotExist:
                return Response({"error": "Organization not found"}, status=404)

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
                "organization_id": organization.id if organization else None,
                "organization_country": organization.organization_country
                if organization
                else None,
            },
            status=201,
        )


class JoinOrganizationApiView(APIView):
    permission_classes = [AllowAny]

    @transaction.atomic
    def post(self, request):
        employee_id = request.data.get("employee_id")
        organization_id = request.data.get("organization_id")

        if not employee_id or not organization_id:
            return Response(
                {"error": "employee_id and organization_id are required"},
                status=400,
            )

        try:
            employee = Employee.objects.get(id=employee_id)
        except Employee.DoesNotExist:
            return Response({"error": "Employee not found"}, status=404)

        try:
            organization = Organization.objects.get(id=organization_id)
        except Organization.DoesNotExist:
            return Response({"error": "Organization not found"}, status=404)

        employee.employee_organization = organization
        employee.save(update_fields=["employee_organization"])

        return Response(
            {
                "employee_id": employee.id,
                "organization_id": organization.id,
                "message": "Registration completed successfully",
            },
            status=200,
        )


class OrganizationRegistrationApiView(APIView):
    permission_classes = [AllowAny]

    @transaction.atomic
    def post(self, request):
        employee_id = request.data.get("employee_id")
        if not employee_id:
            return Response({"error": "employee_id is required"}, status=400)

        try:
            employee = Employee.objects.get(id=employee_id)
        except Employee.DoesNotExist:
            return Response({"error": "Employee not found"}, status=404)

        try:
            organization = _resolve_or_create_organization(
                organization_id=request.data.get("organization_id"),
                org_name=_collapse_whitespace(request.data.get("organization_name")),
                org_description=_collapse_whitespace(
                    request.data.get("organization_description", "")
                ),
                organization_country=_collapse_whitespace(
                    request.data.get("organization_country", "")
                ),
                years=_collapse_whitespace(request.data.get("years", "")),
                state_name=_collapse_whitespace(request.data.get("state", "")),
                organization_type_name=_collapse_whitespace(
                    request.data.get("organization_type", "")
                ),
                organization_sector=_collapse_whitespace(
                    request.data.get("organization_sector", "")
                ),
                organization_size_name=_collapse_whitespace(
                    request.data.get("organization_size", "")
                ),
                target_audience=_collapse_whitespace(
                    request.data.get("target_audience", "")
                ),
            )
        except ValueError as exc:
            return Response({"error": str(exc)}, status=400)
        except Organization.DoesNotExist:
            return Response({"error": "Organization not found"}, status=404)

        employee.employee_organization = organization
        employee.save(update_fields=["employee_organization"])

        return Response(
            {
                "employee_id": employee.id,
                "organization_id": organization.id,
                "organization_name": organization.name,
                "organization_country": organization.organization_country,
                "message": "Registration completed successfully",
            },
            status=200,
        )


class AddOrganizationApiView(APIView):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsAuthenticated]

    @transaction.atomic
    def post(self, request):
        if not request.user.email:
            return Response(
                {"error": "Authenticated user must have an email."},
                status=400,
            )

        try:
            organization = _resolve_or_create_organization(
                organization_id=request.data.get("organization_id"),
                org_name=_collapse_whitespace(request.data.get("organization_name")),
                org_description=_collapse_whitespace(
                    request.data.get("organization_description", "")
                ),
                organization_country=_collapse_whitespace(
                    request.data.get("organization_country", "")
                ),
                years=_collapse_whitespace(request.data.get("years", "")),
                state_name=_collapse_whitespace(request.data.get("state", "")),
                organization_type_name=_collapse_whitespace(
                    request.data.get("organization_type", "")
                ),
                organization_sector=_collapse_whitespace(
                    request.data.get("organization_sector", "")
                ),
                organization_size_name=_collapse_whitespace(
                    request.data.get("organization_size", "")
                ),
                target_audience=_collapse_whitespace(
                    request.data.get("target_audience", "")
                ),
            )
        except ValueError as exc:
            return Response({"error": str(exc)}, status=400)
        except Organization.DoesNotExist:
            return Response({"error": "Organization not found"}, status=404)

        existing = Employee.objects.filter(
            e_mail__iexact=request.user.email,
            employee_organization=organization,
        ).first()

        if existing:
            return Response(
                {
                    "employee_id": existing.id,
                    "organization_id": organization.id,
                    "organization_name": organization.name,
                    "organization_country": organization.organization_country,
                    "organization_sector": organization.organization_sector,
                    "already_linked": True,
                    "message": "Organization already linked to current user.",
                },
                status=200,
            )

        employee = Employee.objects.create(
            name=request.user.get_full_name().strip() or request.user.username,
            e_mail=request.user.email,
            role=_collapse_whitespace(request.data.get("role", "")),
            employee_organization=organization,
        )

        if not _get_current_organization_id(request.user):
            _set_current_organization(request.user, organization.id)

        return Response(
            {
                "employee_id": employee.id,
                "organization_id": organization.id,
                "organization_name": organization.name,
                "organization_country": organization.organization_country,
                "organization_sector": organization.organization_sector,
                "already_linked": False,
                "message": "Organization linked to current user.",
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
            {
                "id": e.employee_organization.id,
                "name": e.employee_organization.name,
                "organization_country": e.employee_organization.organization_country,
                "organization_sector": e.employee_organization.organization_sector,
            }
            for e in employees
            if e.employee_organization
        ]

        current_organization_id = _resolve_current_organization_id(
            user,
            [org["id"] for org in organizations],
        )

        employee_id = employees.first().id if employees.exists() else None

        response_data = {
            "id": user.id,
            "username": user.username,
            "full_name": user.get_full_name().strip() or user.username,
            "email": user.email,
            "is_admin": bool(user.is_staff or user.is_superuser),
            "employee_id": employee_id,
            "organizations": organizations,
            "current_organization_id": current_organization_id,
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


def _normalize_country_name(value):
    return _collapse_whitespace(value or "Brazil")


def _find_organization_by_normalized_name(name, country=None):
    normalized_name = _normalize_organization_name(name)
    if not normalized_name:
        return None

    normalized_country = _normalize_country_name(country) if country else None

    for organization in Organization.objects.only(
        "id", "name", "description", "organization_country"
    ):
        if _normalize_organization_name(organization.name) != normalized_name:
            continue

        if normalized_country:
            organization_country = _normalize_country_name(
                getattr(organization, "organization_country", "")
            )
            if organization_country and organization_country != normalized_country:
                continue

        return organization
    return None


def _resolve_or_create_organization(
    *,
    organization_id,
    org_name,
    org_description,
    organization_country,
    years,
    state_name,
    organization_type_name,
    organization_sector,
    organization_size_name,
    target_audience,
):
    if organization_id:
        return Organization.objects.get(id=organization_id)

    if not org_name:
        raise ValueError(
            "organization_name is required when organization_id is not provided"
        )

    organization_country = _normalize_country_name(organization_country)

    if organization_country.lower() == "brazil" and not state_name:
        raise ValueError("state is required when organization_country is Brazil")

    organization = _find_organization_by_normalized_name(org_name, organization_country)
    if organization and org_description and not organization.description:
        organization.description = org_description
        organization.save(update_fields=["description"])
        return organization

    if organization and organization_country and not organization.organization_country:
        organization.organization_country = organization_country
        organization.save(update_fields=["organization_country"])

    if organization:
        return organization

    organization = Organization.objects.create(
        name=org_name,
        description=org_description,
        organization_country=organization_country,
    )
    fields_to_update = []

    if years:
        organization.years_experience_range = years
        organization.age = _resolve_age_from_years(years)
        fields_to_update.extend(["years_experience_range", "age"])

    if organization_country.lower() == "brazil" and state_name:
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

        if category and organization_type.category_organization_type_id != category.id:
            organization_type.category_organization_type = category
            organization_type.save(update_fields=["category_organization_type"])

        organization.organization_type = organization_type
        fields_to_update.append("organization_type")

    if organization_sector:
        organization.organization_sector = organization_sector
        fields_to_update.append("organization_sector")

    if target_audience:
        organization.target_audience = target_audience
        fields_to_update.append("target_audience")

    if (
        organization_country
        and organization.organization_country != organization_country
    ):
        organization.organization_country = organization_country
        fields_to_update.append("organization_country")

    if fields_to_update:
        organization.save(update_fields=fields_to_update)

    return organization


def _has_membership(user, organization_id):
    if not user or not user.is_authenticated or not user.email or not organization_id:
        return False

    return Employee.objects.filter(
        e_mail__iexact=user.email,
        employee_organization_id=organization_id,
    ).exists()


def _get_linked_organization_count(user):
    if not user or not user.is_authenticated or not user.email:
        return 0

    return (
        Employee.objects.filter(
            e_mail__iexact=user.email, employee_organization__isnull=False
        )
        .values_list("employee_organization_id", flat=True)
        .distinct()
        .count()
    )


def _get_linked_organization_ids(user):
    if not user or not user.is_authenticated or not user.email:
        return []

    return list(
        Employee.objects.filter(
            e_mail__iexact=user.email,
            employee_organization__isnull=False,
        )
        .values_list("employee_organization_id", flat=True)
        .distinct()
    )


def _get_current_organization_id(user):
    if not user or not user.is_authenticated:
        return None

    preference = UserOrganizationPreference.objects.filter(user=user).first()
    if not preference or not preference.current_organization_id:
        return None

    return preference.current_organization_id


def _set_current_organization(user, organization_id):
    preference, _ = UserOrganizationPreference.objects.get_or_create(user=user)
    preference.current_organization_id = organization_id
    preference.save(update_fields=["current_organization"])


def _resolve_current_organization_id(user, linked_organization_ids=None):
    linked_ids = linked_organization_ids or _get_linked_organization_ids(user)
    if not linked_ids:
        preference = UserOrganizationPreference.objects.filter(user=user).first()
        if preference and preference.current_organization_id is not None:
            preference.current_organization = None
            preference.save(update_fields=["current_organization"])
        return None

    current_id = _get_current_organization_id(user)
    if current_id in linked_ids:
        return current_id

    fallback_id = linked_ids[0]
    _set_current_organization(user, fallback_id)
    return fallback_id


def _switch_current_organization(user, organization_id):
    if not _has_membership(user, organization_id):
        return False

    _set_current_organization(user, organization_id)
    return True


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

            if _get_linked_organization_count(request.user) <= 1:
                return Response(
                    {
                        "error": "You must stay linked to at least one organization before quitting this one."
                    },
                    status=400,
                )

        deleted_payload = {
            "id": member.id,
            "organization_id": member.employee_organization_id,
            "deleted_self": same_user,
        }
        removed_organization_id = member.employee_organization_id
        member.employee_organization = None
        member.save(update_fields=["employee_organization"])

        if (
            same_user
            and removed_organization_id
            and _get_current_organization_id(request.user) == removed_organization_id
        ):
            _resolve_current_organization_id(request.user)

        return Response(deleted_payload, status=200)


class QuitOrganizationApiView(APIView):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsAuthenticated]

    @transaction.atomic
    def post(self, request):
        organization_id = request.data.get("organization_id")
        if not organization_id:
            return Response({"error": "organization_id is required"}, status=400)

        try:
            organization_id_int = int(organization_id)
        except (TypeError, ValueError):
            return Response(
                {"error": "organization_id must be a valid integer"}, status=400
            )

        if not _has_membership(request.user, organization_id_int):
            return Response(
                {"error": "You do not have access to this organization."},
                status=403,
            )

        if _get_linked_organization_count(request.user) <= 1:
            return Response(
                {
                    "error": "You must stay linked to at least one organization before quitting this one."
                },
                status=400,
            )

        updated = Employee.objects.filter(
            e_mail__iexact=request.user.email,
            employee_organization_id=organization_id_int,
        ).update(employee_organization=None)

        if updated == 0:
            return Response({"error": "Active membership not found."}, status=404)

        if _get_current_organization_id(request.user) == organization_id_int:
            _resolve_current_organization_id(request.user)

        return Response(
            {
                "organization_id": int(organization_id),
                "membership_id": None,
                "ended_at": timezone.now(),
            },
            status=200,
        )


class CurrentOrganizationApiView(APIView):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsAuthenticated]

    def patch(self, request):
        organization_id = request.data.get("organization_id")
        if not organization_id:
            return Response({"error": "organization_id is required"}, status=400)

        try:
            organization_id_int = int(organization_id)
        except (TypeError, ValueError):
            return Response(
                {"error": "organization_id must be a valid integer"},
                status=400,
            )

        if not _switch_current_organization(request.user, organization_id_int):
            return Response(
                {"error": "You do not have access to this organization."},
                status=403,
            )

        organization = (
            Organization.objects.filter(id=organization_id_int).only("name").first()
        )

        return Response(
            {
                "current_organization_id": organization_id_int,
                "current_organization_name": organization.name if organization else "",
            },
            status=200,
        )


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
