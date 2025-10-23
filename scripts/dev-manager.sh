#!/bin/bash

# 🚀 Odoo Development Environment Manager
# Script interactivo para gestionar el entorno de desarrollo

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║       🚀 Odoo Development Manager              ║"
    echo "║            Environment Controller              ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Mostrar estado de contenedores
show_status() {
    echo -e "${BLUE}📊 Estado actual de los servicios:${NC}"
    docker-compose ps 2>/dev/null || echo -e "${RED}❌ No se encontró docker-compose.yml${NC}"
    echo ""
}

# Menú principal
show_menu() {
    echo -e "${YELLOW}🛠️  GESTIÓN DE SERVICIOS:${NC}"
    echo -e "  1. ▶️  Iniciar servicios (docker-compose up -d)"
    echo -e "  2. ⏹️  Detener servicios (docker-compose down)"
    echo -e "  3. 🔄 Reiniciar servicios (docker-compose restart)"
    echo -e "  4. 📋 Ver estado de servicios (docker-compose ps)"
    echo ""
    
    echo -e "${YELLOW}📊 LOGS Y MONITOREO:${NC}"
    echo -e "  5. 📜 Ver logs de Odoo (docker-compose logs -f odoo)"
    echo -e "  6. 📜 Ver logs de PostgreSQL (docker-compose logs -f postgres)"
    echo -e "  7. 📜 Ver logs de todos los servicios"
    echo -e "  8. 🔍 Ver logs en tiempo real (seguimiento)"
    echo ""
    
    echo -e "${YELLOW}🗄️  GESTIÓN DE DATOS:${NC}"
    echo -e "  9. 🗑️  Detener y eliminar volúmenes (docker-compose down -v)"
    echo -e "  10. 🧹 Limpiar sistema Docker (docker system prune)"
    echo -e "  11. 🧹 Limpiar todo (volúmenes + sistema)"
    echo -e "  12. 💾 Backup de base de datos"
    echo -e "  13. 📁 Acceder al contenedor de Odoo (bash)"
    echo ""
    
    echo -e "${YELLOW}🔧 DESARROLLO:${NC}"
    echo -e "  14. 🔄 Rebuild servicios (docker-compose up -d --build)"
    echo -e "  15. 📦 Ver imágenes Docker utilizadas"
    echo -e "  16. 🏷️  Cambiar versión de Odoo (usar switch-odoo-version.sh)"
    echo -e "  17. ⚙️  Editar configuración (odoo.conf)"
    echo -e "  18. ⚙️  Editar docker-compose.yml"
    echo ""
    
    echo -e "${YELLOW}🌐 ACCESOS RÁPIDOS:${NC}"
    echo -e "  20. 🌐 Mostrar enlace a Odoo"
    echo -e "  21. 🌐 Mostrar enlace a pgAdmin"
    echo ""
    
    echo -e "${YELLOW}ℹ️  INFORMACIÓN:${NC}"
    echo -e "  22. 📖 Ver configuración actual"
    echo -e "  23. 🆘 Ayuda y comandos útiles"
    echo ""
    
    echo -e "${RED}0. ❌ Salir${NC}"
    echo ""
}

# Función para ejecutar comandos
execute_option() {
    case $1 in
        1)
            echo -e "${GREEN}▶️  Iniciando servicios...${NC}"
            docker-compose up -d
            ;;
        2)
            echo -e "${YELLOW}⏹️  Deteniendo servicios...${NC}"
            docker-compose down
            ;;
        3)
            echo -e "${BLUE}🔄 Reiniciando servicios...${NC}"
            docker-compose restart
            ;;
        4)
            show_status
            ;;
        5)
            echo -e "${BLUE}📜 Mostrando logs de Odoo (Ctrl+C para salir)...${NC}"
            docker-compose logs -f odoo
            ;;
        6)
            echo -e "${BLUE}📜 Mostrando logs de PostgreSQL (Ctrl+C para salir)...${NC}"
            docker-compose logs -f postgres
            ;;
        7)
            echo -e "${BLUE}📜 Mostrando logs de todos los servicios...${NC}"
            docker-compose logs
            ;;
        8)
            echo -e "${BLUE}🔍 Mostrando logs en tiempo real (Ctrl+C para salir)...${NC}"
            docker-compose logs -f
            ;;
        9)
            echo -e "${RED}🗑️  ¿Estás seguro? Esto eliminará TODOS los datos de la base de datos${NC}"
            read -p "Escribe 'CONFIRMAR' para continuar: " confirm
            if [ "$confirm" = "CONFIRMAR" ]; then
                echo -e "${RED}Eliminando volúmenes...${NC}"
                docker-compose down -v
            else
                echo -e "${YELLOW}Operación cancelada${NC}"
            fi
            ;;
        10)
            echo -e "${YELLOW}🧹 Limpiando sistema Docker...${NC}"
            docker system prune -f
            ;;
        11)
            echo -e "${RED}🧹 ¿Estás seguro? Esto eliminará TODOS los datos y limpiará Docker${NC}"
            read -p "Escribe 'CONFIRMAR' para continuar: " confirm
            if [ "$confirm" = "CONFIRMAR" ]; then
                echo -e "${RED}Limpiando todo...${NC}"
                docker-compose down -v
                docker system prune -f
            else
                echo -e "${YELLOW}Operación cancelada${NC}"
            fi
            ;;
        12)
            echo -e "${BLUE}💾 Creando backup de base de datos...${NC}"
            timestamp=$(date +"%Y%m%d_%H%M%S")
            docker-compose exec postgres pg_dump -U odoo postgres > "backup_${timestamp}.sql"
            echo -e "${GREEN}✅ Backup creado: backup_${timestamp}.sql${NC}"
            ;;
        13)
            echo -e "${BLUE}📁 Accediendo al contenedor de Odoo...${NC}"
            docker-compose exec odoo bash
            ;;
        14)
            echo -e "${BLUE}🔄 Rebuilding servicios...${NC}"
            docker-compose up -d --build
            ;;
        15)
            echo -e "${BLUE}📦 Imágenes Docker utilizadas:${NC}"
            docker-compose images
            ;;
        16)
            echo -e "${BLUE}🏷️  Ejecutando script de cambio de versión...${NC}"
            if [ -f "./scripts/switch-odoo-version.sh" ]; then
                echo "Versiones disponibles: 16, 17, 18, 19"
                read -p "¿Qué versión quieres? " version
                ./scripts/switch-odoo-version.sh $version
            else
                echo -e "${RED}❌ No se encontró scripts/switch-odoo-version.sh${NC}"
            fi
            ;;
        17)
            echo -e "${BLUE}⚙️  Abriendo odoo.conf...${NC}"
            ${EDITOR:-nano} odoo.conf
            ;;
        18)
            echo -e "${BLUE}⚙️  Abriendo docker-compose.yml...${NC}"
            ${EDITOR:-nano} docker-compose.yml
            ;;
        20)
            echo -e "${GREEN}🌐 Enlace a Odoo:${NC}"
            echo -e "${BLUE}http://localhost:8069${NC}"
            echo -e "${YELLOW}💡 Tip: Haz Ctrl+Click en el enlace para abrirlo en tu navegador${NC}"
            ;;
        21)
            echo -e "${GREEN}🌐 Enlace a pgAdmin:${NC}"
            echo -e "${BLUE}http://localhost:8080${NC}"
            echo -e "${YELLOW}💡 Tip: Haz Ctrl+Click en el enlace para abrirlo en tu navegador${NC}"
            ;;
        22)
            echo -e "${BLUE}📖 Configuración actual:${NC}"
            echo ""
            if [ -f "docker-compose.yml" ]; then
                echo -e "${YELLOW}🐳 Versión de Odoo:${NC}"
                grep "image: odoo:" docker-compose.yml | head -1
                echo ""
                echo -e "${YELLOW}🗄️  Versión de PostgreSQL:${NC}"
                grep "image: postgres:" docker-compose.yml | head -1
                echo ""
            fi
            show_status
            ;;
        23)
            echo -e "${BLUE}🆘 Comandos útiles:${NC}"
            echo ""
            echo -e "${YELLOW}Comandos Docker Compose básicos:${NC}"
            echo -e "  docker-compose up -d          # Iniciar servicios"
            echo -e "  docker-compose down           # Detener servicios"
            echo -e "  docker-compose logs -f odoo   # Ver logs de Odoo"
            echo -e "  docker-compose ps             # Ver estado"
            echo ""
            echo -e "${YELLOW}Accesos web:${NC}"
            echo -e "  Odoo: http://localhost:8069"
            echo -e "  pgAdmin: http://localhost:8080"
            echo ""
            echo -e "${YELLOW}Scripts disponibles:${NC}"
            echo -e "  ./scripts/switch-odoo-version.sh [VERSION]  # Cambiar versión de Odoo"
            echo -e "  ./scripts/dev-manager.sh                   # Este script"
            echo -e "  ./scripts/setup-secure.sh                  # Configuración segura"
            ;;
        0)
            echo -e "${GREEN}👋 ¡Hasta luego!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Opción no válida${NC}"
            ;;
    esac
}

# Función principal
main() {
    while true; do
        show_banner
        show_status
        show_menu
        
        read -p "Selecciona una opción [0-23]: " choice
        echo ""
        
        execute_option $choice
        
        echo ""
        read -p "Presiona Enter para continuar..."
    done
}

# Verificar si estamos en el directorio correcto
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Error: No se encontró docker-compose.yml en el directorio actual${NC}"
    echo -e "${YELLOW}💡 Asegúrate de ejecutar este script desde el directorio del proyecto${NC}"
    exit 1
fi

# Ejecutar función principal
main