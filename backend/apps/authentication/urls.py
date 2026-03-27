from django.urls import path
from .views import (
    CurrentUserProfileApiView,
    ForgotPasswordApiView,
    LoginApiView,
    LoginPageView,
    OrganizationSettingsApiView,
    OrganizationSettingsMemberApiView,
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
        "profile/", CurrentUserProfileApiView.as_view(), name="current-user-profile-api"
    ),
    path("register/", RegisterView.as_view()),
]
