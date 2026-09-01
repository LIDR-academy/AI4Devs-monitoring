# LTI - Sistema de Seguimiento de Talento

Este proyecto es una aplicación full-stack con un frontend en React y un backend en Express usando Prisma como un ORM. El frontend se inicia con Create React App y el backend está escrito en TypeScript.

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
````
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

## Entrega Final (Ejercicio Datadog - AWS con Terraform)

### Explicación de los cambios realizados
Para lograr la integración de observabilidad de infraestructura en AWS mediante Datadog, se realizaron las siguientes configuraciones mediante Terraform:
- **`provider.tf`**: Se incluyó y configuró el provider oficial de `DataDog/datadog`, configurando las variables de autenticación `datadog_api_key` y `datadog_app_key`.
- **`integration.tf`**: Se creó el recurso `datadog_integration_aws` y un **Rol de IAM** (`DatadogAWSIntegrationRole`) en AWS con permisos delegados para que la cuenta principal de Datadog asuma dicho rol (`sts:AssumeRole`) de forma segura utilizando un `ExternalId` autogenerado. Se asignó la política de lectura `SecurityAudit`.
- **`dashboard.tf`**: Se desplegó un Dashboard en Datadog ("AWS Infrastructure Observability - EC2") configurado como código para proveer gráficas en tiempo real del tráfico de red (Bytes In/Out), uso de CPU segregado por host/tipo de instancia, y estado de conexión del agente EC2.
- **`main.tf`**: Se incluyó un recurso de monitoreo (`datadog_monitor.ec2_cpu_monitor`) que activa alertas cuando el uso general de CPU pasa el 80% (Critical) o 70% (Warning), taggeando a `@team-devops`.
- **Scripts de User Data (`tf/scripts/`)**: Se modificó `backend_user_data.sh` para **instalar el Agente de Datadog en EC2** inyectándole el `DD_API_KEY`, además de instrumentar APM activando el Trace Agent y configurando variables de entorno en el contenedor del backend para colectar trazas (`DD_APM_ENABLED=true`).
- **Backend (`backend/src/index.ts`)**: Se incluyó la librería `dd-trace` y se inicializó el tracer en el código base (primera línea) para conectar métricas APM de la app NodeJS al host local del agente de Datadog.

### Capturas de pantalla
- **Dashboard en Datadog**:  
  *[INSERTA TU CAPTURA DE PANTALLA DEL DASHBOARD AQUÍ]*

- **Alerta "EC2 CPU Utilization" en Datadog**:  
  *[INSERTA TU CAPTURA DE PANTALLA DE LA ALERTA AQUÍ]*
# LTI - Sistema de Seguimiento de Talento

Este proyecto es una aplicación full-stack con un frontend en React y un backend en Express usando Prisma como un ORM. El frontend se inicia con Create React App y el backend está escrito en TypeScript.

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
````
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

## Entrega Final (Ejercicio Datadog - AWS con Terraform)

### Explicación de los cambios realizados
Para lograr la integración de observabilidad de infraestructura en AWS mediante Datadog, se realizaron las siguientes configuraciones mediante Terraform:
- **`provider.tf`**: Se incluyó y configuró el provider oficial de `DataDog/datadog`, configurando las variables de autenticación `datadog_api_key` y `datadog_app_key`.
- **`integration.tf`**: Se creó el recurso `datadog_integration_aws` y un **Rol de IAM** (`DatadogAWSIntegrationRole`) en AWS con permisos delegados para que la cuenta principal de Datadog asuma dicho rol (`sts:AssumeRole`) de forma segura utilizando un `ExternalId` autogenerado. Se asignó la política de lectura `SecurityAudit`.
- **`dashboard.tf`**: Se desplegó un Dashboard en Datadog ("AWS Infrastructure Observability - EC2") configurado como código para proveer gráficas en tiempo real del tráfico de red (Bytes In/Out), uso de CPU segregado por host/tipo de instancia, y estado de conexión del agente EC2.
- **`main.tf`**: Se incluyó un recurso de monitoreo (`datadog_monitor.ec2_cpu_monitor`) que activa alertas cuando el uso general de CPU pasa el 80% (Critical) o 70% (Warning), taggeando a `@team-devops`.
- **Scripts de User Data (`tf/scripts/`)**: Se modificó `backend_user_data.sh` para **instalar el Agente de Datadog en EC2** inyectándole el `DD_API_KEY`, además de instrumentar APM activando el Trace Agent y configurando variables de entorno en el contenedor del backend para colectar trazas (`DD_APM_ENABLED=true`).
- **Backend (`backend/src/index.ts`)**: Se incluyó la librería `dd-trace` y se inicializó el tracer en el código base (primera línea) para conectar métricas APM de la app NodeJS al host local del agente de Datadog.

### Capturas de pantalla
- **Dashboard en Datadog**:  
  *[INSERTA TU CAPTURA DE PANTALLA DEL DASHBOARD AQUÍ]*

- **Alerta "EC2 CPU Utilization" en Datadog**:  
  *[INSERTA TU CAPTURA DE PANTALLA DE LA ALERTA AQUÍ]*

### Documentación de Prompts
Los prompts utilizados para generar la infraestructura de Terraform relacionada con la integración pueden encontrarse en el siguiente archivo:
[prompts/datadog-aws-prompts.md](./prompts/datadog-aws-prompts.md)

### Desafíos encontrados y su solución
1. **Scope de Archivos Seed de Prisma ignorado por TypeScript**: Al abrir y editar archivos de inserción inicial (`prisma/seed.ts`), el IDE de TypeScript marcaba error en variables globales de Node.js (como `process.exit()`). 
   - *Solución*: Se agregó la ruta `"prisma/**/*.ts"` a la sección `include` del `tsconfig.json` del backend, permitiendo que el compilador TypeScript tomara en cuenta los tipos de `@types/node` instalados y resolviera exitosamente el error.
2. **Dependencias del APM sobre Docker**: Se requería monitoreo profundo de la aplicación, pero la app corre aislada en su propio contenedor dentro de un EC2 que corre el Agente Host. 
   - *Solución*: Se enviaron variables de entorno (`DD_AGENT_HOST`, `DD_ENV`, `DD_SERVICE`, etc.) al comando `docker run` y se activó el flag de tráfico no local (`DD_APM_NON_LOCAL_TRAFFIC`) en la instalación del agente de Datadog, logrando establecer una comunicación bidireccional entre la App containerizada y el proceso del agente host.
3. **Manejo Seguro de Secretos en Infraestructura como Código**: Datadog requería tokens de autenticación para su provisión en Terraform que no debían ser empujados a GitHub.
   - *Solución*: Se movieron las credenciales estáticas sensibles a un archivo de variables locales (`terraform.tfvars`) y se configuró expresamente este patrón de archivo en el `.gitignore` raíz (`**/*.tfvars`) para asegurar que información crítica y secretos del equipo no sean expuestos al subir los cambios y mantener cumplimiento con las instrucciones de seguridad.
