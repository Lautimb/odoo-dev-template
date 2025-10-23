# 🐳 Odoo Development Template - Multi-Version

Un template de desarrollo para Odoo **dinámico y multi-versión** usando Docker Compose. ¡Cambia entre versiones de Odoo con un solo comando!

## 📋 Descripción

Este repositorio es un **template reutilizable avanzado** que proporciona un entorno de desarrollo completo para Odoo usando Docker. Incluye:

- **Odoo Multi-versión**: Soporte dinámico para versiones 16, 17, 18, 19+
- **PostgreSQL**: Base de datos con versiones optimizadas por versión de Odoo
- **pgAdmin**: Interfaz web para administrar la base de datos
- **Script de cambio automático**: Cambia versiones de Odoo con un comando

## 🚀 Características

- ✅ **Multi-versión dinámica**: Cambio automático entre Odoo 16, 17, 18, 19+
- ✅ **Script automatizado**: `./switch-odoo-version.sh [VERSION]`
- ✅ **PostgreSQL optimizado**: Versión automática según Odoo
- ✅ **Entorno aislado** con Docker
- ✅ **Hot reload** para desarrollo
- ✅ **Múltiples directorios de addons** configurables
- ✅ **pgAdmin** incluido para gestión de BD
- ✅ **Volúmenes persistentes** para datos
- ✅ **Variables de entorno** configurables
- ✅ **Backup automático** antes de cambios

## 📁 Estructura del Proyecto

```
odoo-dev-template/
├── 📄 docker-compose.yml         # Configuración de servicios
├── 📄 odoo.conf                  # Configuración de Odoo
├── 📄 .env                       # Variables de entorno
├── 📄 .env.example               # Template de variables
├── 📄 entrypoint.sh              # Script de inicialización
├── 🚀 odoo-dev.sh                # 🆕 Script principal (punto de entrada)
├── 📂 scripts/                   # 🆕 Scripts de desarrollo
│   ├── 🔄 switch-odoo-version.sh # Script de cambio de versión
│   ├── 🎛️  dev-manager.sh        # Gestor completo de desarrollo
│   ├── 🔒 setup-secure.sh        # Configuración segura inicial
│   └── 📄 README.md              # Documentación de scripts
├── 📂 addons/                    # 🔧 Tus módulos personalizados
├── 📂 enterprise/                # 🔧 Módulos enterprise (opcional)
└── 📄 README.md                  # Este archivo
```

## 🛠️ Configuración Inicial (Quick Start)

### 1. 📥 Clonar y configurar
```bash
# Clonar el template
git clone https://github.com/Lautimb/odoo-dev-template.git my-odoo-project
cd my-odoo-project

# Opcional: cambiar origen para tu proyecto
git remote set-url origin https://github.com/tu-usuario/tu-proyecto-odoo.git
```

### 2. ⚙️ Configurar variables de entorno

**Opción A: Configuración segura automática (Recomendado)**
```bash
# Generar configuración con passwords seguros
./scripts/setup-secure.sh
```

**Opción B: Configuración manual**
```bash
# Copiar template de configuración
cp .env.example .env

# Editar configuraciones (passwords, emails, etc.)
nano .env  # o tu editor preferido
```

### 3. 🎯 Elegir versión de Odoo

**Opción A: Script principal (Más fácil)**
```bash
# Ejecutar script principal
./odoo-dev.sh
# Seleccionar opción 2 para cambiar versión
```

**Opción B: Script directo**
```bash
# Cambiar a Odoo 18 (actual por defecto)
./scripts/switch-odoo-version.sh 18

# O cambiar a Odoo 17
./scripts/switch-odoo-version.sh 17
```

**Opción C: Manual**
```bash
# Solo cambiar y levantar (ya está en Odoo 18)
docker-compose up -d
```

### 4. 🌐 Acceso a las aplicaciones

- **Odoo**: http://localhost:8069
- **pgAdmin**: http://localhost:8080

## 🔄 Cambio Dinámico de Versiones

### 🚀 Script Automático (Nuevo!)

**Método 1: Script principal**
```bash
./odoo-dev.sh
# Seleccionar opción 2: "Cambiar versión de Odoo"
```

**Método 2: Script directo**
```bash
# Sintaxis
./scripts/switch-odoo-version.sh [VERSION]

# Ejemplos
./scripts/switch-odoo-version.sh 17    # Cambiar a Odoo 17
./scripts/switch-odoo-version.sh 18    # Cambiar a Odoo 18
./scripts/switch-odoo-version.sh 19    # Cambiar a Odoo 19
```

### ⚡ Lo que hace el script automáticamente:

1. 🛑 **Detiene servicios** corriendo
2. 💾 **Crea backup** de docker-compose.yml
3. 🔄 **Actualiza versión** de Odoo
4. 🗄️ **Ajusta PostgreSQL** a versión compatible
5. 🌐 **Actualiza red** Docker
6. 🧹 **Opción de limpiar** volúmenes (opcional)
7. 🚀 **Inicia servicios** automáticamente

### 📊 Versiones soportadas y PostgreSQL:

| Odoo | PostgreSQL | Estado |
|------|------------|--------|
| 16   | 14         | ✅ Soportado |
| 17   | 15         | ✅ Soportado |
| 18   | 17.0       | ✅ Soportado (por defecto) |
| 19   | 17.0       | ✅ Soportado |

## � Configuraciones Avanzadas

### 🗂️ Personalizar directorios de addons

Editar `docker-compose.yml` y `odoo.conf`:

```yaml
# docker-compose.yml - sección volumes
volumes:
  - ./mis-modulos/:/mnt/mis-modulos              # 🔧 Cambiar nombres
  - ./modulos-empresa/:/mnt/modulos-empresa      # 🔧 Agregar los que necesites
  - ./enterprise/:/mnt/enterprise                # 🔧 Solo si tienes enterprise
```

```ini
# odoo.conf - addons_path
addons_path = /usr/lib/python3/dist-packages/odoo/addons,/mnt/mis-modulos,/mnt/modulos-empresa
```

### 🔐 Configurar variables de entorno

Archivo `.env`:
```bash
# PostgreSQL
POSTGRES_DB=mi_database              # 🔧 Nombre de tu BD
POSTGRES_USER=odoo
POSTGRES_PASSWORD=mi_password_seguro # 🔧 Cambiar password

# Odoo
ODOO_ADMIN_PASSWORD=admin_seguro     # � Password admin de Odoo

# pgAdmin  
PGADMIN_DEFAULT_EMAIL=admin@mi-empresa.com    # 🔧 Tu email
PGADMIN_DEFAULT_PASSWORD=password_pgadmin     # 🔧 Tu password
```

### 🌐 Configurar puertos personalizados

Si el puerto 8069 está ocupado:
```yaml
# docker-compose.yml
ports:
  - "8070:8069"  # Cambiar puerto local
```

### 🐛 Modo desarrollo

En `odoo.conf`:
```ini
# Agregar al final del archivo
dev_mode = reload,qweb,werkzeug,xml
auto_reload = True
```

## 📚 Useful Commands

```bash
# Service status
docker-compose ps

# Stop services
docker-compose down

# Complete rebuild
docker-compose up -d --build

# Access Odoo container
docker-compose exec odoo bash

# View resource usage
docker stats
```

## 🎯 Common Use Cases

### New project with Odoo 18
1. Change `image: odoo:18` in docker-compose.yml
2. Create `my-project/` folder for modules
3. Update addons_path
4. `docker-compose up -d`

### Migration from Odoo 16 to 17
1. Backup current database
2. Change `image: odoo:17`
3. Migrate custom modules
4. Restore database and update

### Multi-company development
1. Add multiple addon folders
2. Configure appropriate addons_path
3. Use different ports if you need multiple instances

## 🤝 Contributing

Contributions are welcome!

1. Fork este repositorio
2. Crea tu rama: `git checkout -b mejora/nueva-caracteristica`
3. Commit: `git commit -am 'Agregar nueva característica'`
4. Push: `git push origin mejora/nueva-caracteristica`
5. Abre un Pull Request

## 📄 Licencia

MIT License - Libre para uso personal y comercial.

## 🆘 Soporte

- 🐛 **Issues**: [GitHub Issues](https://github.com/Lautimb/odoo-17/issues)
- 📖 **Docs Odoo**: [odoo.com/documentation](https://www.odoo.com/documentation/)
- 🐳 **Docker**: [docs.docker.com](https://docs.docker.com/)

---

⭐ **¿Te sirvió este template? ¡Dale una estrella!** ⭐

## 🗄️ Base de Datos

### Conexión directa a PostgreSQL

```bash
# Conectar via docker
docker-compose exec postgres psql -U odoo -d postgres

# Conectar desde host
psql -h localhost -p 5432 -U odoo -d postgres
```

### Backup y Restore

```bash
# Backup
docker-compose exec postgres pg_dump -U odoo postgres > backup.sql

# Restore
docker-compose exec -T postgres psql -U odoo postgres < backup.sql
```

## 🐛 Troubleshooting

### Problemas comunes

**Error de permisos**:
```bash
sudo chown -R 101:101 ./data/odoo
```

**Puerto ocupado**:
```bash
# Cambiar puertos en docker-compose.yml
ports:
  - "8070:8069"  # Cambiar 8069 por 8070
```

**Limpiar entorno**:
```bash
docker-compose down -v
docker-compose up -d
```

## 📚 Comandos Útiles

```bash
# Parar servicios
docker-compose down

# Rebuild containers
docker-compose up -d --build

# Ver estado de servicios
docker-compose ps

# Ejecutar comando en contenedor
docker-compose exec odoo bash

# Limpiar volúmenes (⚠️ Elimina datos)
docker-compose down -v
```

## 🤝 Contributing

Contributions are welcome!

1. Fork este repositorio
2. Crea tu rama: `git checkout -b mejora/nueva-caracteristica`
3. Commit: `git commit -am 'Agregar nueva característica'`
4. Push: `git push origin mejora/nueva-caracteristica`
5. Abre un Pull Request

## 📄 Licencia

MIT License - Libre para uso personal y comercial.

## 🆘 Soporte

- 🐛 **Issues**: [GitHub Issues](https://github.com/Lautimb/odoo-17/issues)
- 📖 **Docs Odoo**: [odoo.com/documentation](https://www.odoo.com/documentation/)
- 🐳 **Docker**: [docs.docker.com](https://docs.docker.com/)

---

⭐ **¿Te sirvió este template? ¡Dale una estrella!** ⭐
