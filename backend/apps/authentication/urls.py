from django.urls import path
from .views import (
    AddOrganizationApiView,
    CurrentOrganizationApiView,
    CurrentUserProfileApiView,
    ForgotPasswordApiView,
    JoinOrganizationApiView,
    LoginApiView,
    LoginPageView,
    OrganizationRegistrationApiView,
    OrganizationSettingsApiView,
    OrganizationSettingsMemberApiView,
    QuitOrganizationApiView,
    RegisterView,
)

urlpatterns = [
    path("login/", LoginPageView.as_view(), name="login-page"),
    path("login-api/", LoginApiView.as_view(), name="login-api"),
    path(
        "forgot-password/", ForgotPasswordApiView.as_view(), name="forgot-password-api"
    ),
    path(
        "organization-settings/",
        OrganizationSettingsApiView.as_view(),
        name="organization-settings-api",
    ),
    path(
        "organization-settings/members/<int:member_id>/",
        OrganizationSettingsMemberApiView.as_view(),
        name="organization-settings-member-api",
    ),
    path(
        "organization-settings/quit/",
        QuitOrganizationApiView.as_view(),
        name="organization-settings-quit-api",
    ),
    path("join-organization/", JoinOrganizationApiView.as_view()),
    path("organization-registration/", OrganizationRegistrationApiView.as_view()),
    path("add-organization/", AddOrganizationApiView.as_view()),
    path("current-organization/", CurrentOrganizationApiView.as_view()),
    path(
        "profile/", CurrentUserProfileApiView.as_view(), name="current-user-profile-api"
    ),
    path("register/", RegisterView.as_view()),
]
