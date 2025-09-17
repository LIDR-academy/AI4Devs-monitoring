Eres un experto en Ingenieria de Prompts y en DevSecOps
# Contexto Inicial
Tenemos un proyecto listo que se enfoca en el reclutamiento de candidatos, ahora buscamos desplegar el proyecto completo en la nube de AWS

# Intrucciones generales
Tu tarea es generar un prompt para el chatboot (ChatGPT 4.1) que me ayude a desplegar el backend y frontend de mi proyecto en AWS mediante terraform cumpliendo con las siguientes instrucciones

# Instrucciones
- La infraestructura consta de una instancias EC2 del tipo t2.micro
- Tendras que hacer checkout del proyecto mediante git desde la siguiente url del proyecto: `https://github.com/rockeroicantonidev/AI4Devs-monitoring.git`, no requieres crendiales ya que el repositorio es publico
- el backend debe ser accesible por medio del puerto 8080
- el frontend debe ser accesible por medio del puerto 3000
- No es necesario solicitar nombres de keys ya que ya se encuentran configuradas con aws configure
- Utiliza terraform en la carpeta @tf

# Mejores practicas
- Incluye el rol en el que debe actual el chatbot

# Consideraciones adicionales
- El chatbot tendrá acceso al codigo del proyecto para implementar la configuracion correctamente.

# Pautas para generar el contenido
1. El formato de salida va ser un archivo con extensión .md y el contenido en formato Markdown

Antes de generar el prompt revisa mis instrucciones ¿me esta faltando algo por considerar?
Realiza preguntas si necesitas mas información.




# Prompt para Chatbot (ChatGPT 4.1) - Despliegue de Proyecto en AWS con Terraform

## Rol del Chatbot
Actúa como un **DevSecOps Engineer experto en AWS y Terraform**, encargado de desplegar y configurar la infraestructura necesaria para el proyecto de reclutamiento de candidatos.

## Objetivo
Desplegar el backend y frontend del proyecto [AI4Devs-monitoring](https://github.com/rockeroicantonidev/AI4Devs-monitoring.git) en AWS usando Terraform, siguiendo las mejores prácticas y cumpliendo los siguientes requisitos:

---

## Requisitos de Infraestructura

- **Instancia EC2:**  
  - Tipo: `t2.micro`
  - AMI: Amazon Linux 2
  - Región: `us-west-1`
  - Acceso SSH: Puerto 22 abierto a todo el mundo
  - Backend accesible por el puerto 8080
  - Frontend accesible por el puerto 3000
  - Ambas aplicaciones corren en la misma instancia
  - Acceso mediante IP pública (no requiere dominio)
  - No requiere almacenamiento adicional

- **Configuración de Seguridad:**  
  - Security Group con reglas para puertos 22 (SSH), 8080 (backend) y 3000 (frontend), todos abiertos a cualquier IP.

- **Automatización:**  
  - Incluir en el `user_data` de la instancia los comandos necesarios para instalar dependencias y ejecutar el backend y frontend automáticamente al iniciar la instancia.  
  - El chatbot podrá revisar los archivos del proyecto para determinar los comandos y dependencias necesarias.

- **Terraform:**  
  - Utilizar la carpeta `tf` para toda la configuración de infraestructura.
  - No es necesario solicitar nombres de keys, ya están configuradas con `aws configure`.

---

## Instrucciones para el Chatbot

1. **Clona el repositorio público:**  
   `https://github.com/rockeroicantonidev/AI4Devs-monitoring.git`

2. **Revisa los archivos del proyecto** para identificar los comandos de instalación y arranque de backend y frontend.

3. **Genera los archivos de Terraform** en la carpeta `tf` para:
   - Crear la instancia EC2 con Amazon Linux 2 en `us-west-1`
   - Configurar el Security Group con los puertos 22, 8080 y 3000 abiertos
   - Proveer acceso SSH mediante la IP pública
   - Automatizar la instalación de dependencias y el arranque de los servicios usando `user_data`

4. **Incluye tags y outputs útiles** en la configuración de Terraform (por ejemplo, IP pública de la instancia).

## Consideraciones Adicionales

- El chatbot tiene acceso al código fuente y puede revisar los archivos para implementar la configuración correctamente.
- No hay restricciones de presupuesto ni límites de uso por el momento.
- No es necesario configurar dominios ni almacenamiento adicional.


## Mejores Prácticas

- Sigue las recomendaciones de seguridad y organización de recursos en AWS.
- Utiliza variables y outputs en Terraform para facilitar la administración.

## Pautas para generar el contenido:
- Genera una lista de pasos para realizar la implementación de los archivos necesarios
- Cada paso se va ejecutar de manera individual por lo que me tienes que preguntar si podemos pasar al siguiente
- En cada paso de la lista menciona el archivo que se va a crear o modificar e incluye el código que se va agregar

Antes de realizar la tarea revisa mis requisitos ¿hay algo que me este faltando considerar?
Hazme preguntas si necesitas más información.






Eres un experto en Ingenieria de Prompts y en DevSecOps
# Contexto Inicial
Tenemos un proyecto listo que se enfoca en el reclutamiento de candidatos, ahora buscamos simular el despliegue del proyecto completo en la nube de AWS mediante el uso de LocalStack

# Intrucciones generales
Tu tarea es generar un prompt para el chatboot (ChatGPT 4.1) que me ayude a simular el despliegue del backend y frontend de mi proyecto en LocalStack para simular AWS mediante terraform cumpliendo con las siguientes instrucciones

# Instrucciones
- La infraestructura consta de una instancias EC2 del tipo t2.micro
- Tendras que hacer checkout del proyecto mediante git desde la siguiente url del proyecto: `https://github.com/rockeroicantonidev/AI4Devs-monitoring.git`, no requieres crendiales ya que el repositorio es publico
- el backend debe ser accesible por medio del puerto 8080
- el frontend debe ser accesible por medio del puerto 3000
- No es necesario solicitar nombres de keys ya que ya se encuentran configuradas con aws configure
- Utiliza terraform en la carpeta @tf

# Mejores practicas
- Incluye el rol en el que debe actual el chatbot

# Consideraciones adicionales
- El chatbot tendrá acceso al codigo del proyecto para implementar la configuracion correctamente.
- Estoy utilizando Windows 11
- Tengo instalado Terraform pero no tengo instalado Python

# Pautas para generar el contenido
1. El formato de salida va ser un archivo con extensión .md y el contenido en formato Markdown

Antes de generar el prompt revisa mis instrucciones ¿me esta faltando algo por considerar?
Realiza preguntas si necesitas mas información.










# Prompt para Chatbot (ChatGPT 4.1) - Simulación de Despliegue en LocalStack usando Terraform

## Rol del Chatbot
Actúa como un **DevSecOps Engineer experto en AWS, Terraform y simulaciones con LocalStack en Windows 11**, encargado de simular el despliegue y configuración de la infraestructura necesaria para el proyecto de reclutamiento de candidatos.

## Objetivo
Simular el despliegue del backend y frontend del proyecto [AI4Devs-monitoring](https://github.com/rockeroicantonidev/AI4Devs-monitoring.git) en LocalStack usando Terraform, siguiendo las mejores prácticas y cumpliendo los siguientes requisitos:

---

## Requisitos de Simulación

- **Infraestructura simulada:**  
  - Instancia EC2 tipo `t2.micro` (simulada en LocalStack)
  - Backend accesible por el puerto 8080
  - Frontend accesible por el puerto 3000
  - Ambas aplicaciones corren en la misma instancia simulada
  - Acceso mediante IP local (simulando la IP pública de EC2)
  - No requiere otros servicios AWS (solo EC2 simulado)

- **Configuración de Seguridad:**  
  - Simular reglas de apertura de puertos 22 (SSH), 8080 (backend) y 3000 (frontend) en la máquina local

- **Automatización:**  
  - Incluir pasos para instalar LocalStack en Windows 11 usando Docker
  - El chatbot debe revisar los archivos del proyecto para determinar los comandos y dependencias necesarias
  - Simular el arranque de backend y frontend localmente, como si estuvieran en EC2
  - Utilizar Cmander para facilitar la ejecución de scripts en Windows

- **Terraform:**  
  - Utilizar la carpeta `tf` para toda la configuración de infraestructura simulada
  - No es necesario solicitar nombres de keys, ya están configuradas con `aws configure`

---

## Instrucciones para el Chatbot

1. **Clona el repositorio público:**  
   `https://github.com/rockeroicantonidev/AI4Devs-monitoring.git`

2. **Instala LocalStack en Windows 11** usando Docker, proporcionando los comandos necesarios.

3. **Instala Node.js en Windows 11** si es requerido por el backend/frontend, proporcionando los pasos y comandos necesarios.

4. **Revisa los archivos del proyecto** para identificar los comandos de instalación y arranque de backend y frontend.

5. **Genera los archivos de Terraform** en la carpeta `tf` para simular la creación de una instancia EC2 y la apertura de puertos.

6. **Simula el arranque de los servicios** (backend y frontend) en la máquina local, utilizando scripts compatibles con Windows y Cmander para facilitar la ejecución.

7. **Documenta el proceso** en el archivo Markdown, explicando cada paso y decisión tomada.

---

## Consideraciones Adicionales

- El chatbot tiene acceso al código fuente y puede revisar los archivos para implementar la configuración correctamente.
- No es necesario instalar Docker, ya está instalado.
- No hay restricciones de presupuesto ni límites de uso por el momento.
- No es necesario configurar dominios ni almacenamiento adicional.

---

## Mejores Prácticas

- Sigue las recomendaciones de seguridad y organización de recursos simulados.
- Documenta los pasos para futuras actualizaciones o mantenimiento.
- Utiliza variables y outputs en Terraform para facilitar la administración.

## Pautas para generar el contenido:
- Genera una lista de pasos para realizar la implementación de los archivos necesarios
- Cada paso se va ejecutar de manera individual por lo que me tienes que preguntar si podemos pasar al siguiente
- En cada paso de la lista menciona el archivo que se va a crear o modificar e incluye el código que se va agregar

Antes de realizar la tarea revisa mis requisitos ¿hay algo que me este faltando considerar?
Hazme preguntas si necesitas más información.





Eres un experto en Ingenieria de Prompts y en DevSecOps
# Contexto Inicial
Tenemos un proyecto listo que se enfoca en el reclutamiento de candidatos, actualmente utilizamos Terraform y Local Stack para simular el despliegue a la nube de AWS, el cual se ejecuta correctamente. Ahora se busca integrar DataDog para el monitorio de la aplicación.

# Intrucciones generales
Tu tarea es generar un prompt para el chatboot (ChatGPT 4.1) que me ayude a integrar DataDog en el despligue de Terraform cumpliendo con los siguiente que se pide:

# Objetivos
La misión es extender el código Terraform existente para:
- Configurar la integración de Datadog con AWS usando Terraform.
- Instalar el agente Datadog en la instancia EC2.
- Crear un dashboard en Datadog para visualizar métricas clave de AWS.

# Pasos sugeridos
* Configurar la Integración AWS-Datadog:
  - Utilizar Terraform para configurar la integración entre Local Stack simulando AWS y Datadog.
* Configurar el Proveedor Datadog:
  - Instrucciones para añadir el proveedor Datadog a la configuración de Terraform.
* Instalar el Agente Datadog:
  - Modificar los scripts de usuario de la instancia EC2 para instalar y configurar el agente Datadog.
* Crear un Dashboard:
  - Utilizar Terraform para definir un dashboard en Datadog que muestre métricas relevantes de la infraestructura AWS.

# Mejores practicas
- Incluye el rol en el que debe actual el chatbot

# Consideraciones adicionales
- El chatbot tendrá acceso al codigo del proyecto para implementar la configuracion correctamente.
- Estoy utilizando Windows 11
- Tengo instalado Terraform, Docker, los contenedores de Base de datos y Local Stack se encuentran en ejecución

# Pautas para generar el contenido
1. El formato de salida va ser un archivo con extensión .md y el contenido en formato Markdown

Antes de generar el prompt revisa mis instrucciones ¿me esta faltando algo por considerar?
Realiza preguntas si necesitas mas información.







# Prompt para Chatbot (ChatGPT 4.1) - Integración de DataDog en Despliegue Simulado con Terraform y LocalStack

## Rol del Chatbot
Actúa como un **DevSecOps Engineer experto en AWS, Terraform, LocalStack y DataDog**, encargado de integrar DataDog en el despliegue simulado de la aplicación de reclutamiento de candidatos.

## Objetivo
Extender el código Terraform existente para:
- Configurar la integración de DataDog con AWS usando Terraform y LocalStack.
- Instalar el agente DataDog en la instancia EC2 simulada.
- Crear un dashboard en DataDog para visualizar métricas clave de AWS.
- Configurar alertas/notificaciones relevantes en el dashboard.

---

## Instrucciones para el Chatbot

1. **Configurar la integración AWS-DataDog:**
   - Indica cómo obtener la API Key y Application Key de DataDog y dónde configurarlas en Terraform.
   - Utiliza Terraform para simular la integración entre LocalStack (AWS) y DataDog.

2. **Configurar el proveedor DataDog:**
   - Proporciona instrucciones para añadir el proveedor DataDog en la configuración de Terraform (`provider.tf`).

3. **Instalar el agente DataDog:**
   - Modifica los scripts de usuario de la instancia EC2 simulada para instalar y configurar el agente DataDog.

4. **Crear un dashboard en DataDog:**
   - Utiliza Terraform para definir un dashboard en DataDog que muestre métricas relevantes para una instancia EC2 (CPU, memoria, tráfico de red, logs, etc.).
   - Sugiere las métricas más relevantes de acuerdo al ambiente simulado.
   - Configura alertas/notificaciones en el dashboard.

## Consideraciones Adicionales

- El chatbot tiene acceso al código fuente y puede revisar los archivos para implementar la configuración correctamente.
- El agente DataDog debe instalarse en la instancia EC2 simulada por LocalStack.
- El entorno es Windows 11, con Terraform, Docker, contenedores de base de datos y LocalStack en ejecución.
- El chatbot debe indicar cómo obtener y configurar las credenciales de DataDog.

## Mejores Prácticas

- Sigue las recomendaciones de seguridad y organización de recursos simulados.
- Documenta los pasos para futuras actualizaciones o mantenimiento.
- Utiliza variables y outputs en Terraform para facilitar la administración.

## Pautas para generar el contenido:
- Genera una lista de pasos para realizar la implementación de los archivos necesarios
- Cada paso se va ejecutar de manera individual por lo que me tienes que preguntar si podemos pasar al siguiente
- En cada paso de la lista menciona el archivo que se va a crear o modificar e incluye el código que se va agregar

Antes de realizar la tarea revisa mis requisitos ¿hay algo que me este faltando considerar?
Hazme preguntas si necesitas más información.