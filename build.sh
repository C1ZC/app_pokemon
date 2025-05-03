#!/usr/bin/env bash
# exit on error
set -o errexit

# Instalar dependencias de SQL Server
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/microsoft-keyring.gpg] https://packages.microsoft.com/debian/11/prod bullseye main" | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools
sudo apt-get install -y unixodbc-dev


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