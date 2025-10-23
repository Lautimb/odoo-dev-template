# 📜 Scripts de Desarrollo

Esta carpeta contiene todos los scripts útiles para el desarrollo con Odoo.

## 🚀 Scripts Disponibles

### `switch-odoo-version.sh` 
**Cambio dinámico de versión de Odoo**
```bash
./scripts/switch-odoo-version.sh 18
```
- Cambia automáticamente entre versiones de Odoo (16, 17, 18, 19)
- Ajusta PostgreSQL a versión compatible
- Crea backups automáticos
- Opción de limpiar volúmenes

### `dev-manager.sh`
**Gestor completo de desarrollo**
```bash
./scripts/dev-manager.sh
```
- Menú interactivo con todas las opciones
- Gestión de servicios (start, stop, restart)
- Logs y monitoreo
- Gestión de datos y backups
- Herramientas de desarrollo

### `setup-secure.sh`
**Configuración segura inicial**
```bash
./scripts/setup-secure.sh
```
- Genera passwords seguros automáticamente
- Crea archivo `.env` con configuración segura
- Ideal para configuración inicial del proyecto

## 🎯 Uso Recomendado

### Primera vez:
1. `./scripts/setup-secure.sh` - Configuración inicial segura
2. `./scripts/switch-odoo-version.sh 18` - Configurar versión deseada
3. `docker-compose up -d` - Iniciar servicios

### Desarrollo diario:
- `./scripts/dev-manager.sh` - Para gestión completa
- O usar el script principal: `./odoo-dev.sh`

## 🔒 Seguridad

Todos los scripts están diseñados con seguridad en mente:
- Generación de passwords seguros
- Validaciones antes de operaciones destructivas
- Configuraciones apropiadas para desarrollo vs producción

## 📝 Notas

- Todos los scripts deben ejecutarse desde la raíz del proyecto
- Verifican automáticamente la presencia de `docker-compose.yml`
- Incluyen mensajes informativos y confirmaciones para operaciones críticas