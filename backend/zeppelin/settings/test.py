from .base import *
from decouple import config


DEBUG = True

SECRET_KEY = config("SECRET_KEY", default="zeppelin-test-secret")

DATABASES = {
    "default": {
        "ENGINE": config(
            "DB_ENGINE_TEST",
            default="django.db.backends.sqlite3",
        ),
        "NAME": config("DB_NAME_TEST", default=":memory:"),
        "USER": config("DB_USER_TEST", default=""),
        "PASSWORD": config("DB_PASSWORD_TEST", default=""),
        "HOST": config("DB_HOST_TEST", default=""),
        "PORT": config("DB_PORT_TEST", default=""),
    }
}

PASSWORD_HASHERS = [
    "django.contrib.auth.hashers.MD5PasswordHasher",
]

EMAIL_BACKEND = "django.core.mail.backends.locmem.EmailBackend"

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
}
