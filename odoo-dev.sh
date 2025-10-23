#!/bin/bash

# 🚀 Odoo Development Template - Main Script
# Script principal para gestionar el entorno de desarrollo

# Verificar si estamos en el directorio correcto
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: No se encontró docker-compose.yml en el directorio actual"
    echo "💡 Asegúrate de ejecutar este script desde el directorio del proyecto"
    exit 1
fi

# Banner
echo "🐳 Odoo Development Template"
echo "============================"
echo ""
echo "Selecciona una opción:"
echo ""
echo "1. 🎛️  Abrir gestor de desarrollo (menú completo)"
echo "2. 🔄 Cambiar versión de Odoo"
echo "3. 🔒 Configuración segura inicial"
echo "4. ▶️  Inicio rápido (docker-compose up -d)"
echo "5. ⏹️  Parar servicios (docker-compose down)"
echo "6. 📊 Ver estado de servicios"
echo "7. 📜 Ver logs de Odoo"
echo ""
echo "0. ❌ Salir"
echo ""

read -p "Opción [0-7]: " choice
echo ""

case $choice in
    1)
        echo "🎛️  Abriendo gestor de desarrollo..."
        ./scripts/dev-manager.sh
        ;;
    2)
        echo "🔄 Cambiar versión de Odoo..."
        echo "Versiones disponibles: 16, 17, 18, 19"
        read -p "¿Qué versión quieres? " version
        ./scripts/switch-odoo-version.sh $version
        ;;
    3)
        echo "🔒 Configuración segura inicial..."
        ./scripts/setup-secure.sh
        ;;
    4)
        echo "▶️  Iniciando servicios..."
        docker-compose up -d
        echo ""
        echo "✅ Servicios iniciados"
        echo "🌐 Odoo: http://localhost:8069"
        echo "🌐 pgAdmin: http://localhost:8080"
        ;;
    5)
        echo "⏹️  Deteniendo servicios..."
        docker-compose down
        echo "✅ Servicios detenidos"
        ;;
    6)
        echo "📊 Estado de servicios:"
        docker-compose ps
        ;;
    7)
        echo "📜 Logs de Odoo (Ctrl+C para salir):"
        docker-compose logs -f odoo
        ;;
    0)
        echo "👋 ¡Hasta luego!"
        exit 0
        ;;
    *)
        echo "❌ Opción no válida"
        exit 1
        ;;
esac