from django.urls import path
from .views import LoginApiView, LoginPageView, RegisterView

urlpatterns = [
    path('login/', LoginPageView.as_view(), name='login-page'),
    path('login-api/', LoginApiView.as_view(), name='login-api'),
    path('register/', RegisterView.as_view()),
]
