from .base import *

# Este settings e usado apenas na execucao automatizada de testes.
# Ele herda da configuracao base, mas simplifica banco, email e logs para rodar mais rapido.
from decouple import config


DEBUG = True

SECRET_KEY = config("SECRET_KEY", default="zeppelin-test-secret")
TEST_DATABASE_NAME = config("DB_NAME_TEST", default=str(BASE_DIR / "test.sqlite3"))

# Por padrao, os testes usam SQLite em arquivo para ficarem leves e previsiveis no CI.
DATABASES = {
    "default": {
        "ENGINE": config(
            "DB_ENGINE_TEST",
            default="django.db.backends.sqlite3",
        ),
        "NAME": TEST_DATABASE_NAME,
        "USER": config("DB_USER_TEST", default=""),
        "PASSWORD": config("DB_PASSWORD_TEST", default=""),
        "HOST": config("DB_HOST_TEST", default=""),
        "PORT": config("DB_PORT_TEST", default=""),
        "TEST": {
            "NAME": TEST_DATABASE_NAME,
        },
    }
}


# Hasher simplificado para acelerar criacao e autenticacao de usuarios nos testes.
PASSWORD_HASHERS = [
    "django.contrib.auth.hashers.MD5PasswordHasher",
]


# Evita envio real de emails durante os testes.
EMAIL_BACKEND = "django.core.mail.backends.locmem.EmailBackend"


# Remove a dependencia de arquivo de log fisico no ambiente de teste.
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
}
