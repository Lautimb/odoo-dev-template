#!/bin/bash

# 🔒 Generador de configuración segura para Odoo Development Template
# Este script genera passwords seguros y crea el archivo .env

set -e

echo "🔒 Generador de Configuración Segura - Odoo Template"
echo "=================================================="
echo ""

# Verificar si .env ya existe
if [ -f ".env" ]; then
    echo "⚠️  El archivo .env ya existe."
    read -p "¿Quieres sobrescribirlo? [y/N]: " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Operación cancelada"
        exit 1
    fi
fi

echo "🔐 Generando passwords seguros..."

# Generar passwords aleatorios
POSTGRES_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
ODOO_ADMIN_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
PGADMIN_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)

# Solicitar email para pgAdmin
echo ""
read -p "📧 Email para pgAdmin [admin@company.com]: " PGADMIN_EMAIL
PGADMIN_EMAIL=${PGADMIN_EMAIL:-admin@company.com}

# Crear archivo .env
cat > .env << EOF
# ===========================================
# 🐳 Odoo Development Environment Template
# ===========================================
# Archivo generado automáticamente - $(date)

# 🗄️ PostgreSQL Database Configuration
POSTGRES_USER=odoo
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
POSTGRES_DB=postgres

# 🔐 Odoo Configuration
ODOO_ADMIN_PASSWORD=${ODOO_ADMIN_PASSWORD}
ODOO_HOST=localhost
HOST=postgres
USER=odoo
PASSWORD=${POSTGRES_PASSWORD}

# 🌐 pgAdmin Configuration
PGADMIN_DEFAULT_EMAIL=${PGADMIN_EMAIL}
PGADMIN_DEFAULT_PASSWORD=${PGADMIN_PASSWORD}
PGADMIN_LISTEN_PORT=80

# 🚀 Development Settings (Optional)
# ODOO_EXTRA_ARGS=--dev=all
# ODOO_LOG_LEVEL=debug
EOF

echo ""
echo "✅ Archivo .env creado con passwords seguros!"
echo ""
echo "🔑 Credenciales generadas:"
echo "========================="
echo "PostgreSQL Password: ${POSTGRES_PASSWORD}"
echo "Odoo Admin Password: ${ODOO_ADMIN_PASSWORD}"
echo "pgAdmin Email: ${PGADMIN_EMAIL}"
echo "pgAdmin Password: ${PGADMIN_PASSWORD}"
echo ""
echo "⚠️  IMPORTANTE:"
echo "- Guarda estas credenciales en un lugar seguro"
echo "- NO commitees el archivo .env a git"
echo "- Para producción, cambia las configuraciones de desarrollo"
echo ""
echo "🚀 Próximo paso: docker-compose up -d"