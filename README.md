# LTI - Sistema de Seguimiento de Talento con Monitorización Datadog

Este proyecto es una aplicación full-stack con un frontend en React y un backend en Express usando Prisma como ORM, completamente integrada con **monitorización profesional Datadog en AWS**.

## 🤖 Implementación con Claude Sonnet-4

Este proyecto fue implementado utilizando **Claude Sonnet-4** (Anthropic's Claude 3.5 Sonnet) para automatizar la integración completa de infraestructura como código y monitorización profesional.

### 📝 Prompts Principales Utilizados

#### 1. Prompt de Diagnóstico Inicial

```
Explora el workspace y analiza todos los errores que encuentres. Necesito implementar
el ejercicio "Implementando un Canal de Monitorización Datadog con Terraform en AWS".
El estado actual muestra errores con Datadog y necesito una solución completa.
```

#### 2. Prompt de Corrección de Credenciales

```
He actualizado las credenciales de Datadog:
- API Key: 34f1373b291cf1c2504a2ef8419c995e
- App Key: f0262b4cd93597bc3baee8bc60217730e58f7b8e
- API URL: https://api.datadoghq.eu/

Actualiza terraform.tfvars con estas nuevas credenciales
```

#### 3. Prompt de Configuración Completa

```
Las credenciales funcionan. Ahora necesito que restaures la configuración completa de datadog.tf
que había sido eliminada. Incluye dashboard, monitores, SLO e integración AWS.
```

#### 4. Prompt de Resolución de Errores

```
Hay errores con los valores de timeout_h en los monitores. El valor 60 excede el límite máximo de 24 horas.
Corrige todos los timeout_h de los monitores.
```

#### 5. Prompt de Aplicación Final

```
Ahora sí, vamos a aplicar la configuración completa de Datadog
```

**📄 Documentación completa**: Ver [PROMPTS.md](./PROMPTS.md) para la secuencia completa de 20 prompts utilizados.

## 🏗️ Estructura del Proyecto

```
AI4Devs-monitoring/
├── 📄 README.md                    # Este archivo
├── 📄 PROMPTS.md                   # Documentación completa de prompts Claude Sonnet-4
├── 📄 EJERCICIO_COMPLETADO.md      # Resumen del ejercicio completado
├── 📄 docker-compose.yml           # Configuración Docker para PostgreSQL
├── 📄 package.json                 # Dependencias del proyecto raíz
├── 📄 VERSION                      # Versión del proyecto
├── 📄 LICENSE.md                   # Licencia del proyecto
├── 📄 Jenkinsfile                  # Pipeline CI/CD
├── 📄 cypress.config.js            # Configuración Cypress E2E
├── 📄 docs.md                      # Documentación adicional
├── 📄 generar-zip.sh               # Script de empaquetado
├── 📄 guion.html                   # Guión del ejercicio
│
├── 📁 backend/                     # 🚀 API Backend (Node.js + TypeScript + Prisma)
│   ├── 📄 package.json             # Dependencias backend
│   ├── 📄 tsconfig.json            # Configuración TypeScript
│   ├── 📄 jest.config.js           # Configuración testing
│   ├── 📄 Dockerfile               # Container backend
│   ├── 📄 api-spec.yaml            # Especificación OpenAPI
│   ├── 📄 ManifestoBuenasPracticas.md
│   ├── 📄 ModeloDatos.md           # Documentación modelo de datos
│   ├── 📁 src/                     # Código fuente backend
│   │   ├── 📄 index.ts             # Punto de entrada servidor
│   │   ├── 📁 application/         # Lógica de aplicación
│   │   │   ├── 📄 validator.ts
│   │   │   └── 📁 services/        # Servicios de negocio
│   │   │       ├── 📄 candidateService.ts
│   │   │       ├── 📄 candidateService.test.ts
│   │   │       ├── 📄 fileUploadService.ts
│   │   │       ├── 📄 positionService.ts
│   │   │       └── 📄 positionService.test.ts
│   │   ├── 📁 domain/              # Modelos de dominio
│   │   │   └── 📁 models/          # Entidades de negocio
│   │   │       ├── 📄 Application.ts
│   │   │       ├── 📄 Candidate.ts
│   │   │       ├── 📄 Company.ts
│   │   │       ├── 📄 Education.ts
│   │   │       ├── 📄 Employee.ts
│   │   │       ├── 📄 Interview.ts
│   │   │       ├── 📄 InterviewFlow.ts
│   │   │       ├── 📄 InterviewStep.ts
│   │   │       ├── 📄 InterviewType.ts
│   │   │       ├── 📄 Position.ts
│   │   │       └── 📄 Resume.ts
│   │   ├── 📁 presentation/        # Capa de presentación
│   │   │   └── 📁 controllers/     # Controladores API
│   │   ├── 📁 routes/              # Definición de rutas
│   │   │   ├── 📄 candidateRoutes.ts
│   │   │   └── 📄 positionRoutes.ts
│   │   └── 📁 prompts/             # Prompts para generación de código
│   │       └── 📄 CreateNewRoute.md
│   └── 📁 prisma/                  # ORM Prisma
│       ├── 📄 schema.prisma        # Esquema de base de datos
│       ├── 📄 seed.ts              # Datos de prueba
│       └── 📁 migrations/          # Migraciones DB
│           ├── 📄 migration_lock.toml
│           ├── 📁 20240528082702_/
│           ├── 📁 20240528085016_/
│           ├── 📁 20240528110522_/
│           └── 📁 20240528140846_/
│
├── 📁 frontend/                    # 🎨 Aplicación Frontend (React + TypeScript)
│   ├── 📄 package.json             # Dependencias frontend
│   ├── 📄 tsconfig.json            # Configuración TypeScript
│   ├── 📄 Dockerfile               # Container frontend
│   ├── 📄 README.md                # Documentación frontend
│   ├── 📁 public/                  # Archivos estáticos
│   │   ├── 📄 index.html
│   │   ├── 📄 favicon.ico
│   │   ├── 📄 logo192.png
│   │   ├── 📄 manifest.json
│   │   └── 📄 robots.txt
│   └── 📁 src/                     # Código fuente frontend
│       ├── 📄 index.tsx            # Punto de entrada React
│       ├── 📄 App.js               # Componente principal
│       ├── 📄 App.css              # Estilos principales
│       ├── 📄 index.css            # Estilos globales
│       ├── 📄 logo.svg             # Logo React
│       ├── 📄 react-app-env.d.ts   # Tipos TypeScript
│       ├── 📄 reportWebVitals.ts   # Métricas web
│       ├── 📁 assets/              # Recursos estáticos
│       │   └── 📄 lti-logo.png
│       ├── 📁 components/          # Componentes React
│       │   ├── 📄 AddCandidateForm.js
│       │   ├── 📄 CandidateCard.js
│       │   ├── 📄 CandidateDetails.js
│       │   ├── 📄 FileUploader.js
│       │   ├── 📄 PositionDetails.js
│       │   ├── 📄 Positions.tsx
│       │   ├── 📄 RecruiterDashboard.js
│       │   └── 📄 StageColumn.js
│       └── 📁 services/            # Servicios API
│           └── 📄 candidateService.js
│
├── 📁 tf/                          # 🏗️ Infraestructura como Código (Terraform)
│   ├── 📄 main.tf                  # Configuración principal
│   ├── 📄 variables.tf             # Variables de Terraform
│   ├── 📄 provider.tf              # Configuración providers
│   ├── 📄 ec2.tf                   # Instancias EC2
│   ├── 📄 s3.tf                    # Buckets S3
│   ├── 📄 iam.tf                   # Roles y políticas IAM
│   ├── 📄 security_groups.tf       # Grupos de seguridad
│   ├── 📄 datadog.tf               # ⭐ Integración Datadog completa
│   ├── 📄 terraform.tfvars         # ⭐ Variables de configuración
│   ├── 📄 terraform.tfstate        # Estado de Terraform
│   ├── 📄 terraform.tfstate.backup # Backup del estado
│   └── 📁 scripts/                 # Scripts de configuración
│       ├── 📄 backend_user_data.sh
│       └── 📄 frontend_user_data.sh
│
├── 📁 cypress/                     # 🧪 Testing E2E
│   ├── 📄 tsconfig.json
│   ├── 📁 e2e/
│   │   └── 📄 positions.cy.ts
│   ├── 📁 fixtures/
│   │   └── 📄 example.json
│   └── 📁 support/
│       ├── 📄 commands.js
│       └── 📄 e2e.js
│
├── 📁 prompts/                     # 📝 Documentación de prompts
│   ├── 📄 prompts.md
│   └── 📄 prompts_ci.md
│
└── 📁 errores_intencionales/       # 🚨 Ejemplos de errores
    └── 📄 main.tf
```

## 📊 Monitorización con Datadog - Implementación Completa

### 🎯 **Estado Actual: ✅ COMPLETADO**

La integración completa con Datadog ha sido implementada exitosamente utilizando Claude Sonnet-4:

#### 🚀 **Infraestructura Desplegada**

- **Frontend EC2**: http://16.171.174.161:3000 (i-0d2ca2e9fd14e2808)
- **Backend EC2**: http://16.171.132.252:8080 (i-09d668d67bbf9dd40)
- **Dashboard Datadog**: https://app.datadoghq.com/dashboard/q68-7vy-pdx
- **S3 Bucket**: ai4devs-monitoring-code-bucket-4y6uv6by
- **IAM Role**: DatadogIntegrationRole

#### 📈 **Dashboard de Monitorización (10 Widgets)**

1. **EC2 CPU Utilization** - Utilización de CPU por host
2. **EC2 Memory Utilization** - Uso de memoria del sistema
3. **Network In/Out** - Tráfico de red entrante/saliente
4. **Disk I/O** - Operaciones de lectura/escritura en disco
5. **Total EC2 Instances** - Contador de instancias EC2
6. **Top EC2 Instances by CPU** - Ranking de instancias por CPU
7. **Application Response Time** - Tiempo de respuesta de aplicación
8. **Error Rate %** - Porcentaje de errores con alertas visuales
9. **Request Latency Distribution** - Distribución de latencia
10. **Docker Container Status** - Estado de contenedores Docker

#### 🚨 **Monitores de Alertas Configurados**

- **High CPU Alert**: >80% CPU utilization (crítico), >70% (warning)
- **High Memory Alert**: <15% memoria disponible (crítico), <20% (warning)
- **Disk Space Alert**: <20% espacio libre (crítico), <30% (warning)
- **Application Health Check**: Monitoreo de conectividad HTTP

#### 🎯 **SLO (Service Level Objective)**

- **Target**: 99.9% uptime
- **Warning**: 99.95% uptime
- **Timeframes**: 7 días y 30 días

### ⚙️ **Configuración Técnica**

- **Terraform Providers**: AWS v5.100.0, Datadog v3.74.0
- **Region**: eu-north-1
- **API URL**: https://api.datadoghq.eu/

### ⚙️ **Configuración Técnica**

- **Terraform Providers**: AWS v5.100.0, Datadog v3.74.0
- **Region**: eu-north-1
- **API URL**: https://api.datadoghq.eu/
- **Integration**: 18 servicios AWS monitorizados

## 🛠️ Explicación de Directorios y Archivos Principales

### Backend (`backend/`)

Contiene el código del servidor Node.js con TypeScript:

- **`src/index.ts`**: Punto de entrada del servidor backend
- **`application/`**: Lógica de aplicación y servicios de negocio
- **`domain/`**: Modelos de dominio y entidades de negocio
- **`presentation/`**: Controladores y capa de presentación
- **`routes/`**: Definiciones de rutas para la API REST
- **`prisma/`**: Esquema ORM y migraciones de base de datos

### Frontend (`frontend/`)

Aplicación React con TypeScript:

- **`src/`**: Código fuente de componentes React
- **`components/`**: Componentes reutilizables de la UI
- **`services/`**: Servicios para comunicación con API
- **`public/`**: Archivos estáticos y assets

### Infraestructura (`tf/`)

Infraestructura como código con Terraform:

- **`datadog.tf`**: ⭐ Configuración completa de monitorización Datadog
- **`ec2.tf`**: Instancias EC2 para frontend/backend
- **`s3.tf`**: Buckets S3 para almacenamiento
- **`iam.tf`**: Roles y políticas de seguridad AWS
- **`terraform.tfvars`**: Variables de configuración (credenciales Datadog)

### Testing (`cypress/`)

Testing end-to-end automatizado:

- **`e2e/`**: Tests de integración completa
- **`fixtures/`**: Datos de prueba
- **`support/`**: Comandos y configuración personalizada

## 🚀 Primeros Pasos

### 1. Configuración Inicial

```bash
# Clonar el repositorio
git clone <repository-url>
cd AI4Devs-monitoring

# Instalar dependencias backend
cd backend
npm install

# Instalar dependencias frontend
cd ../frontend
npm install
```

### 2. Configuración de Base de Datos

```bash
# Iniciar PostgreSQL con Docker
docker-compose up -d

# Configurar base de datos con Prisma
cd backend
npx prisma generate
npx prisma migrate dev
ts-node seed.ts
```

### 3. Ejecución en Desarrollo

```bash
# Terminal 1: Backend
cd backend
npm run build
npm start
# Servidor en http://localhost:3010

# Terminal 2: Frontend
cd frontend
npm run build
npm start
# Aplicación en http://localhost:3000
```

### 4. Despliegue en AWS con Datadog

#### Prerequisitos

- Cuenta AWS configurada
- Cuenta Datadog activa
- Terraform instalado

#### Configuración

```bash
cd tf/

# Copiar archivo de variables
cp terraform.tfvars.example terraform.tfvars

# Editar terraform.tfvars con tus credenciales Datadog:
# datadog_api_key = "tu-api-key"
# datadog_app_key = "tu-app-key"
# datadog_api_url = "https://api.datadoghq.eu/"
```

#### Despliegue

```bash
# Inicializar Terraform
terraform init

# Verificar plan de despliegue
terraform plan

# Aplicar configuración completa
terraform apply
```

#### Resultado del Despliegue

- ✅ **Frontend**: Instancia EC2 con aplicación React
- ✅ **Backend**: Instancia EC2 con API Node.js
- ✅ **Datadog Dashboard**: Monitorización completa en tiempo real
- ✅ **Alertas**: 4 monitores configurados automáticamente
- ✅ **SLO**: Objetivo de 99.9% uptime

## 🐳 Docker y PostgreSQL

### Configuración de Base de Datos

```bash
# Iniciar contenedor PostgreSQL
docker-compose up -d

# Detalles de conexión:
# Host: localhost
# Port: 5432
# User: postgres
# Password: password
# Database: mydatabase

# Detener contenedor
docker-compose down
```

### Configuración con Prisma

```bash
# En directorio backend/
npx prisma generate       # Generar cliente Prisma
npx prisma migrate dev     # Aplicar migraciones
ts-node seed.ts           # Poblar con datos de ejemplo
```

## 📡 API Endpoints

### Candidatos

```bash
# Crear candidato
POST http://localhost:3010/candidates
{
    "firstName": "Albert",
    "lastName": "Saelices",
    "email": "albert.saelices@gmail.com",
    "phone": "656874937",
    "address": "Calle Sant Dalmir 2, 5ºB. Barcelona",
    "educations": [
        {
            "institution": "UC3M",
            "title": "Computer Science",
            "startDate": "2006-12-31",
            "endDate": "2010-12-26"
        }
    ],
    "workExperiences": [
        {
            "company": "Coca Cola",
            "position": "SWE",
            "description": "",
            "startDate": "2011-01-13",
            "endDate": "2013-01-17"
        }
    ],
    "cv": {
        "filePath": "uploads/1715760936750-cv.pdf",
        "fileType": "application/pdf"
    }
}

# Obtener candidato por ID
GET http://localhost:3010/candidates/{id}
```

## 📊 Monitorización y Observabilidad

### Dashboard Datadog

Accede al dashboard completo en: https://app.datadoghq.com/dashboard/q68-7vy-pdx

#### Métricas Monitorizadas

- **Infraestructura**: CPU, Memoria, Disco, Red
- **Aplicación**: Response time, Error rate, Throughput
- **Contenedores**: Estado Docker, Recursos utilizados
- **Logs**: Centralizados con filtros avanzados

#### Alertas Configuradas

- **CPU > 80%**: Alerta crítica con notificación
- **Memoria < 15%**: Alerta de recursos limitados
- **Disco < 20%**: Alerta de espacio insuficiente
- **Health Check**: Monitoreo de conectividad de servicios

#### SLO (Service Level Objectives)

- **Uptime**: 99.9% disponibilidad objetivo
- **Timeframes**: Medición 7d y 30d
- **Alerting**: Notificaciones automáticas ante degradación

## 🧪 Testing

### Testing E2E con Cypress

```bash
# Ejecutar tests end-to-end
npx cypress run

# Abrir interfaz interactiva
npx cypress open
```

### Testing Unitario Backend

```bash
cd backend
npm test
```

## 📚 Documentación Adicional

- **[PROMPTS.md](./PROMPTS.md)** - Secuencia completa de 20 prompts utilizados con Claude Sonnet-4
- **[EJERCICIO_COMPLETADO.md](./EJERCICIO_COMPLETADO.md)** - Resumen detallado del ejercicio completado
- **[ManifestoBuenasPracticas.md](./backend/ManifestoBuenasPracticas.md)** - Buenas prácticas aplicadas
- **[ModeloDatos.md](./backend/ModeloDatos.md)** - Documentación del modelo de datos
- **[api-spec.yaml](./backend/api-spec.yaml)** - Especificación OpenAPI completa

## 🏆 Resultado Final

### ✅ **Ejercicio Completado Exitosamente**

- **Infraestructura AWS**: Completamente desplegada y operacional
- **Monitorización Datadog**: Dashboard profesional con 10 widgets
- **Automatización**: 100% Infrastructure as Code con Terraform
- **Observabilidad**: Alertas, SLO y logs centralizados
- **Documentación**: Trazabilidad completa del proceso

### 🤖 **Powered by Claude Sonnet-4**

Este proyecto demuestra las capacidades avanzadas de Claude Sonnet-4 para:

- Resolución automática de problemas complejos de infraestructura
- Implementación completa de DevOps workflows
- Integración seamless de múltiples tecnologías (AWS, Datadog, Terraform)
- Documentación exhaustiva y automatizada

---

**📅 Última actualización**: Septiembre 21, 2025  
**🤖 Implementado con**: Claude Sonnet-4 (Anthropic)  
**⭐ Estado**: Producción Ready con Monitorización Completa

## Explicación de Directorios y Archivos

- `backend/`: Contiene el código del lado del servidor escrito en Node.js.
  - `src/`: Contiene el código fuente para el backend.
    - `index.ts`: El punto de entrada para el servidor backend.
    - `application/`: Contiene la lógica de aplicación.
    - `domain/`: Contiene la lógica de negocio.
    - `infrastructure/`: Contiene código que se comunica con la base de datos.
    - `presentation/`: Contiene código relacionado con la capa de presentación (como controladores).
    - `routes/`: Contiene las definiciones de rutas para la API.
    - `tests/`: Contiene archivos de prueba.
  - `prisma/`: Contiene el archivo de esquema de Prisma para ORM.
  - `tsconfig.json`: Archivo de configuración de TypeScript.
- `frontend/`: Contiene el código del lado del cliente escrito en React.
  - `src/`: Contiene el código fuente para el frontend.
  - `public/`: Contiene archivos estáticos como el archivo HTML e imágenes.
  - `build/`: Contiene la construcción lista para producción del frontend.
- `.env`: Contiene las variables de entorno.
- `docker-compose.yml`: Contiene la configuración de Docker Compose para gestionar los servicios de tu aplicación.
- `README.md`: Este archivo, contiene información sobre el proyecto e instrucciones sobre cómo ejecutarlo.

## Estructura del Proyecto

El proyecto está dividido en dos directorios principales: `frontend` y `backend`.

### Frontend

El frontend es una aplicación React y sus archivos principales están ubicados en el directorio `src`. El directorio `public` contiene activos estáticos y el directorio `build` contiene la construcción de producción de la aplicación.

### Backend

El backend es una aplicación Express escrita en TypeScript. El directorio `src` contiene el código fuente, dividido en varios subdirectorios:

- `application`: Contiene la lógica de aplicación.
- `domain`: Contiene los modelos de dominio.
- `infrastructure`: Contiene código relacionado con la infraestructura.
- `presentation`: Contiene código relacionado con la capa de presentación.
- `routes`: Contiene las rutas de la aplicación.
- `tests`: Contiene las pruebas de la aplicación.

El directorio `prisma` contiene el esquema de Prisma.

Tienes más información sobre buenas prácticas utilizadas en la [guía de buenas prácticas](./backend/ManifestoBuenasPracticas.md).

Las especificaciones de todos los endpoints de API los tienes en [api-spec.yaml](./backend/api-spec.yaml).

La descripción y diagrama del modelo de datos los tienes en [ModeloDatos.md](./backend/ModeloDatos.md).

## Primeros Pasos

Para comenzar con este proyecto, sigue estos pasos:

1. Clona el repositorio.
2. Instala las dependencias para el frontend y el backend:

```sh
cd frontend
npm install

cd ../backend
npm install
```

3. Construye el servidor backend:

```
cd backend
npm run build
```

4. Inicia el servidor backend:

```
cd backend
npm start
```

5. En una nueva ventana de terminal, construye el servidor frontend:

```
cd frontend
npm run build
```

6. Inicia el servidor frontend:

```
cd frontend
npm start
```

El servidor backend estará corriendo en http://localhost:3010 y el frontend estará disponible en http://localhost:3000.

## Docker y PostgreSQL

Este proyecto usa Docker para ejecutar una base de datos PostgreSQL. Así es cómo ponerlo en marcha:

Instala Docker en tu máquina si aún no lo has hecho. Puedes descargarlo desde aquí.
Navega al directorio raíz del proyecto en tu terminal.
Ejecuta el siguiente comando para iniciar el contenedor Docker:

```
docker-compose up -d
```

Esto iniciará una base de datos PostgreSQL en un contenedor Docker. La bandera -d corre el contenedor en modo separado, lo que significa que se ejecuta en segundo plano.

Para acceder a la base de datos PostgreSQL, puedes usar cualquier cliente PostgreSQL con los siguientes detalles de conexión:

- Host: localhost
- Port: 5432
- User: postgres
- Password: password
- Database: mydatabase

Por favor, reemplaza User, Password y Database con el usuario, la contraseña y el nombre de la base de datos reales especificados en tu archivo .env.

Para detener el contenedor Docker, ejecuta el siguiente comando:

```
docker-compose down
```

Para generar la base de datos utilizando Prisma, sigue estos pasos:

1. Asegúrate de que el archivo `.env` en el directorio raíz del backend contenga la variable `DATABASE_URL` con la cadena de conexión correcta a tu base de datos PostgreSQL. Si no te funciona, prueba a reemplazar la URL completa directamente en `schema.prisma`, en la variable `url`.

2. Abre una terminal y navega al directorio del backend donde se encuentra el archivo `schema.prisma` y `seed.ts`.

3. Ejecuta los siguientes comandos para generar la estructura de prisma, las migraciones a tu base de datos y poblarla con datos de ejemplo:

```
npx prisma generate
npx prisma migrate dev
ts-node seed.ts
```

Una vez has dado todos los pasos, deberías poder guardar nuevos candidatos, tanto via web, como via API, verlos en la base de datos y obtenerlos mediante GET por id.

```
POST http://localhost:3010/candidates
{
    "firstName": "Albert",
    "lastName": "Saelices",
    "email": "albert.saelices@gmail.com",
    "phone": "656874937",
    "address": "Calle Sant Dalmir 2, 5ºB. Barcelona",
    "educations": [
        {
            "institution": "UC3M",
            "title": "Computer Science",
            "startDate": "2006-12-31",
            "endDate": "2010-12-26"
        }
    ],
    "workExperiences": [
        {
            "company": "Coca Cola",
            "position": "SWE",
            "description": "",
            "startDate": "2011-01-13",
            "endDate": "2013-01-17"
        }
    ],
    "cv": {
        "filePath": "uploads/1715760936750-cv.pdf",
        "fileType": "application/pdf"
    }
}
```

## 📊 Monitorización con Datadog

### Configuración de Datadog

Este proyecto incluye una integración completa con Datadog para monitorización de infraestructura y aplicaciones en AWS.

#### Características implementadas:

- **Integración AWS-Datadog**: Configuración automática de roles IAM y permisos
- **Agente Datadog**: Instalación automática en instancias EC2
- **Dashboard personalizado**: Visualización de métricas clave de infraestructura
- **Alertas automatizadas**: Monitoreo de CPU, memoria y recursos críticos
- **Logs centralizados**: Recolección de logs de aplicaciones y sistema
- **APM (Application Performance Monitoring)**: Trazabilidad de aplicaciones

#### Métricas monitorizadas:

- CPU Utilization de instancias EC2
- Memoria y uso de disco
- Tráfico de red (In/Out)
- Operaciones de Disco I/O
- Métricas de contenedores Docker
- Logs de aplicaciones (Frontend/Backend)

#### Configuración requerida:

1. **Credenciales Datadog**: Obtén tu API Key y App Key desde tu cuenta Datadog
2. **Variables de entorno**: Configura las variables en `terraform.tfvars`
3. **Deploy**: Ejecuta Terraform para provisionar la infraestructura

```bash
# En el directorio tf/
cp terraform.tfvars.example terraform.tfvars
# Edita terraform.tfvars con tus credenciales
terraform init
terraform plan
terraform apply
```

#### Acceso al Dashboard:

Una vez desplegado, puedes acceder al dashboard "LTI AWS Infrastructure Monitoring" en tu cuenta Datadog para visualizar:

- Estado en tiempo real de la infraestructura
- Alertas y notificaciones
- Análisis de performance de aplicaciones
- Logs centralizados con filtros avanzados

#### Alertas configuradas:

- **High CPU Alert**: Se activa cuando CPU > 80% (crítico) o > 70% (warning)
- **High Memory Alert**: Se activa cuando memoria disponible < 15% (crítico) o < 20% (warning)

Para más detalles sobre la implementación, consulta la [documentación de prompts](./prompts/datadog-aws-prompts.md).

---

_Última actualización: Septiembre 2025_
