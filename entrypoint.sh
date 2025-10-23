#!/bin/bash

set -e

# Set the postgres database host, port, user, and password from environment variables
: ${DB_HOST:=${HOST:-'postgres'}}
: ${DB_PORT:=5432}
: ${DB_USER:=${USER:-'odoo'}}
: ${DB_PASSWORD:=${PASSWORD:-'your_secure_password'}}

# Path to the Odoo configuration file
ODOO_RC="/etc/odoo/odoo.conf"

# Function to check if a parameter exists in the config file and use it if present
DB_ARGS=()
function check_config() {
    param="$1"
    value="$2"
    if grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC" ; then       
        value=$(grep -E "^\s*\b${param}\b\s*=" "$ODOO_RC" | cut -d " " -f3 | sed 's/["\n\r]//g')
    fi
    DB_ARGS+=("--${param}")
    DB_ARGS+=("${value}")
}

# Check and set database parameters
check_config "db_host" "$DB_HOST"
check_config "db_port" "$DB_PORT"
check_config "db_user" "$DB_USER"
check_config "db_password" "$DB_PASSWORD"

sed "s/{{ODOO_ADMIN_PASSWORD}}/${ODOO_ADMIN_PASSWORD}/g" /etc/odoo/odoo.conf.template > "$ODOO_RC"

# Ensure proper ownership and permissions for Odoo data directory
chown -R odoo:odoo /var/lib/odoo
chmod -R 755 /var/lib/odoo

# Create sessions directory with proper permissions if it doesn't exist
if [ ! -d "/var/lib/odoo/sessions" ]; then
    mkdir -p /var/lib/odoo/sessions
fi
chown -R odoo:odoo /var/lib/odoo/sessions
chmod -R 700 /var/lib/odoo/sessions

echo "DB_HOST=$DB_HOST DB_PORT=$DB_PORT DB_USER=$DB_USER DB_PASSWORD=$DB_PASSWORD" > /tmp/debug.log

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$POSTGRES_DB" -c '\q'; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done
>&2 echo "PostgreSQL is up - executing command"

# Initialize Odoo database (commented out to avoid auto-initialization)
# echo "Initializing Odoo database..."
# odoo --init base \
#   --database="$POSTGRES_DB" \
#   --db_host="$DB_HOST" \
#   --db_port="$DB_PORT" \
#   --db_user="$DB_USER" \
#   --db_password="$DB_PASSWORD" \
#   --stop-after-init

# Start Odoo with proxy mode and bind to all interfaces
echo "Starting Odoo server..."
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="$DB_PORT" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --http-interface=0.0.0.0 \
  --http-port=8069 \
  --proxy-mode