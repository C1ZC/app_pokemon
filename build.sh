#!/usr/bin/env bash
# exit on error
set -o errexit

# Actualizar pip
python -m pip install --upgrade pip

# Instalar dependencias
pip install -r requirements.txt

# Recolectar archivos estáticos
python manage.py collectstatic --no-input

# Aplicar migraciones
python manage.py makemigrations
python manage.py migrate


# Crear superusuario (solo si las variables de entorno están configuradas)
if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_EMAIL" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
    python manage.py createsuperuser --noinput
fi