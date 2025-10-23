#!/bin/bash

# 🐳 Odoo Development Template - Simple Entrypoint
# This is a minimal entrypoint that avoids permission issues

set -e

# Set the postgres database host, port, user, and password from environment variables
: ${DB_HOST:=${HOST:-'postgres'}}
: ${DB_PORT:=5432}
: ${DB_USER:=${USER:-'odoo'}}
: ${DB_PASSWORD:=${PASSWORD:-'your_secure_password'}}

# Path to the Odoo configuration file
ODOO_RC="/etc/odoo/odoo.conf"

echo "🔧 Setting up Odoo configuration..."

# Create Odoo config from template
if [ -f "/etc/odoo/odoo.conf.template" ]; then
    sed "s/{{ODOO_ADMIN_PASSWORD}}/$ODOO_ADMIN_PASSWORD/g" /etc/odoo/odoo.conf.template > "$ODOO_RC"
    echo "✅ Configuration file created from template"
else
    echo "⚠️  No template found, using existing config"
fi

echo "🗄️  Waiting for PostgreSQL to be ready..."
# Wait for PostgreSQL to be ready
until PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$POSTGRES_DB" -c '\q' 2>/dev/null; do
  echo "   PostgreSQL is unavailable - sleeping..."
  sleep 2
done
echo "✅ PostgreSQL is ready!"

echo "🚀 Starting Odoo server..."

# Use Odoo's original entrypoint for better compatibility
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="$DB_PORT" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --http-interface=0.0.0.0 \
  --http-port=8069 \
  --proxy-mode