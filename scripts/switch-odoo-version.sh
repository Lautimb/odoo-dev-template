#!/bin/bash

# Script para cambiar versión de Odoo dinámicamente
# Uso: ./switch-odoo-version.sh [VERSION]
# Ejemplo: ./switch-odoo-version.sh 17

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "╔══════════════════════════════════════╗"
echo "║       🐳 Odoo Version Switcher       ║"
echo "║            Template Manager          ║"
echo "╚══════════════════════════════════════╝"
echo -e "${NC}"

# Función para mostrar uso
show_usage() {
    echo -e "${YELLOW}Uso:${NC}"
    echo "  $0 [VERSIÓN]"
    echo ""
    echo -e "${YELLOW}Versiones soportadas:${NC}"
    echo "  16, 17, 18, 19"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo "  $0 17    # Cambiar a Odoo 17"
    echo "  $0 18    # Cambiar a Odoo 18"
    echo ""
    exit 1
}

# Función para obtener la versión recomendada de PostgreSQL
get_postgres_version() {
    local odoo_version=$1
    case $odoo_version in
        16)
            echo "14-bullseye"
            ;;
        17)
            echo "15-bullseye"
            ;;
        18)
            echo "17.0-bullseye"
            ;;
        19)
            echo "17.0-bullseye"
            ;;
        *)
            echo "17.0-bullseye"  # default
            ;;
    esac
}

# Verificar parámetros
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Error: No se especificó versión de Odoo${NC}"
    show_usage
fi

ODOO_VERSION=$1

# Validar versión
if [[ ! "$ODOO_VERSION" =~ ^(16|17|18|19)$ ]]; then
    echo -e "${RED}❌ Error: Versión no soportada: $ODOO_VERSION${NC}"
    show_usage
fi

POSTGRES_VERSION=$(get_postgres_version $ODOO_VERSION)

echo -e "${BLUE}🔄 Configurando Odoo $ODOO_VERSION...${NC}"
echo -e "📦 PostgreSQL: $POSTGRES_VERSION"

# Verificar si Docker Compose está corriendo
if docker-compose ps | grep -q "Up"; then
    echo -e "${YELLOW}⚠️  Detectado entorno corriendo. Deteniendo servicios...${NC}"
    docker-compose down
fi

# Backup del docker-compose.yml actual
cp docker-compose.yml docker-compose.yml.backup
echo -e "${GREEN}💾 Backup creado: docker-compose.yml.backup${NC}"

# Actualizar docker-compose.yml
echo -e "${BLUE}📝 Actualizando docker-compose.yml...${NC}"

# Cambiar imagen de Odoo
sed -i "s/image: odoo:[0-9]*/image: odoo:$ODOO_VERSION/" docker-compose.yml

# Cambiar imagen de PostgreSQL
sed -i "s/image: postgres:[^[:space:]]*/image: postgres:$POSTGRES_VERSION/" docker-compose.yml

# Actualizar nombre de red (opcional, mantener consistencia)
sed -i "s/odoo_net/odoo${ODOO_VERSION}_net/g" docker-compose.yml

echo -e "${GREEN}✅ docker-compose.yml actualizado${NC}"

# Crear archivo de configuración específico para la versión
echo -e "${BLUE}📝 Creando configuración específica...${NC}"

# Crear .env.example si no existe
if [ ! -f ".env.example" ]; then
    cp .env .env.example
    echo -e "${GREEN}📋 Creado .env.example${NC}"
fi

# Preguntar si quiere limpiar volúmenes
echo ""
echo -e "${YELLOW}🗑️  ¿Quiere limpiar volúmenes de Docker? (Elimina datos de BD)${NC}"
echo -e "   ${RED}⚠️  ATENCIÓN: Esto eliminará todas las bases de datos existentes${NC}"
read -p "   Limpiar volúmenes? [y/N]: " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🧹 Limpiando volúmenes...${NC}"
    docker-compose down -v
    docker system prune -f
    echo -e "${GREEN}✅ Volúmenes limpiados${NC}"
fi

# Mostrar próximos pasos
echo ""
echo -e "${GREEN}🎉 ¡Configuración completada!${NC}"
echo ""
echo -e "${YELLOW}📋 Próximos pasos:${NC}"
echo -e "1. Revisar configuración: ${BLUE}docker-compose.yml${NC}"
echo -e "2. Iniciar servicios: ${BLUE}docker-compose up -d${NC}"
echo -e "3. Ver logs: ${BLUE}docker-compose logs -f odoo${NC}"
echo -e "4. Acceder a Odoo: ${BLUE}http://localhost:8069${NC}"
echo ""

# Mostrar información de versiones
echo -e "${BLUE}📊 Configuración actual:${NC}"
echo -e "   🐳 Odoo: $ODOO_VERSION"
echo -e "   🗄️  PostgreSQL: $POSTGRES_VERSION"
echo -e "   🌐 Red: odoo${ODOO_VERSION}_net"
echo ""

# Mostrar como ejecutar el script
echo -e "${YELLOW}💡 Para cambiar versiones en el futuro:${NC}"
echo -e "   ${BLUE}./switch-odoo-version.sh 17${NC}  # Cambiar a Odoo 17"
echo -e "   ${BLUE}./switch-odoo-version.sh 18${NC}  # Cambiar a Odoo 18"
echo -e "   ${BLUE}./switch-odoo-version.sh 19${NC}  # Cambiar a Odoo 19"
echo ""

# Preguntar si quiere iniciar servicios automáticamente
read -p "¿Iniciar servicios ahora? [Y/n]: " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${BLUE}🚀 Iniciando servicios...${NC}"
    docker-compose up -d
    
    echo ""
    echo -e "${GREEN}✅ Servicios iniciados${NC}"
    echo -e "${BLUE}📋 Estado de servicios:${NC}"
    docker-compose ps
    
    echo ""
    echo -e "${YELLOW}🔗 Enlaces útiles:${NC}"
    echo -e "   Odoo: ${BLUE}http://localhost:8069${NC}"
    echo -e "   pgAdmin: ${BLUE}http://localhost:8080${NC}"
    
    echo ""
    echo -e "${YELLOW}📊 Para ver logs:${NC}"
    echo -e "   ${BLUE}docker-compose logs -f odoo${NC}"
else
    echo -e "${YELLOW}ℹ️  Servicios no iniciados. Para iniciar manualmente:${NC}"
    echo -e "   ${BLUE}docker-compose up -d${NC}"
fi

echo ""
echo -e "${GREEN}🎯 ¡Listo para desarrollar con Odoo $ODOO_VERSION!${NC}"