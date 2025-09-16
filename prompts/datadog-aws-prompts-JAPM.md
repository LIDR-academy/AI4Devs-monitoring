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