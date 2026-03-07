from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User
from django.shortcuts import redirect, render
from django.views import View
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
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
        username = request.data.get("username")
        email = request.data.get("email")
        password = request.data.get("password")
        role = request.data.get("role", "")
        organization_id = request.data.get("organization_id")
        org_name = request.data.get("organization_name")
        org_description = request.data.get("organization_description", "")

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
        return Response(
            {
                "id": user.id,
                "username": user.username,
                "email": user.email,
            },
            status=200,
        )
