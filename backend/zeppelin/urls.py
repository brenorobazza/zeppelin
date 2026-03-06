from django.contrib import admin
from django.urls import path, include

from django.conf import settings
from django.conf.urls.static import static
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi 

schema_view = get_schema_view(
    openapi.Info(
        title="Zeppelin",
        default_version='v1',
        description="Zeppelin",
    ),
    public=True,
    permission_classes=[permissions.AllowAny],
)

urlpatterns = [
    path('admin/doc/', include('django.contrib.admindocs.urls')),
    path('admin/', admin.site.urls),
    path('o/', include('oauth2_provider.urls', namespace='oauth2_provider')), 
    path('', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('', include('apps.sth.api_urls')),
    path('', include('apps.continuousstar.api_urls')),
    path('', include('apps.cseframework.api_urls')),
    path('', include('apps.organization.api_urls')),
    path('', include('apps.employee.api_urls')),
    path('', include('apps.practitionerseye.api_urls')),
    path('', include('apps.questionnaire.api_urls')),
    *static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
