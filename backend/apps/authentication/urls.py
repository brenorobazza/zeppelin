from django.urls import path
from .views import ForgotPasswordApiView, LoginApiView, LoginPageView, RegisterView

urlpatterns = [
    path("login/", LoginPageView.as_view(), name="login-page"),
    path("login-api/", LoginApiView.as_view(), name="login-api"),
    path("forgot-password/", ForgotPasswordApiView.as_view(), name="forgot-password-api"),
    path("register/", RegisterView.as_view()),
]
