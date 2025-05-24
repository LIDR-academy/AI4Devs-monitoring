#Ejercicio: Implementando un Canal de Monitorización Datadog🐶 con Terraform en AWS 

En este ejercicio, ampliaremos nuestro proyecto de infraestructura como código utilizando Terraform para implementar un canal de monitorización de Datadog en AWS. Aprovecharemos técnicas de prompt engineering para automatizar la generación de código, lo que nos permitirá monitorear y obtener insights valiosos de nuestra infraestructura AWS de manera automatizada.

##0. Pre-requisitos:
* Cuenta AWS (capa gratuita)
* Terraform instalado en tu equipo local
* Cuenta Datadog (puedes usar la prueba gratuita)
* Repositorio del ejercicio (código Terraform base del ejercicio anterior) el codigo de la clase anterior esta en este repositorio:
🔗 https://github.com/LIDR-academy/AI4Devs-monitoring 

##1. Configuración Inicial:
* Asegúrate de tener configuradas tus credenciales de AWS y Datadog en tu entorno local.
* Revisa el código Terraform generado en el ejercicio anterior.
* Familiarízate con las técnicas de prompt engineering para la generación de código automatizado.

##2. Objetivo del Ejercicio:
Tu misión es extender el código Terraform existente para:

* Configurar la integración de Datadog con AWS usando Terraform.
* Instalar el agente Datadog en la instancia EC2.
* Crear un dashboard en Datadog para visualizar métricas clave de AWS.

##3. Pasos a Seguir:
a) Configurar la Integración AWS-Datadog:
* Utiliza Terraform para configurar la integración entre AWS y Datadog, siguiendo la guía proporcionada.
b) Configurar el Proveedor Datadog:
* Añade el proveedor Datadog a tu configuración de Terraform.
c) Instalar el Agente Datadog:
* Modifica el script de usuario de la instancia EC2 para instalar y configurar el agente Datadog.
d) Crear un Dashboard:
* Utiliza Terraform para definir un dashboard en Datadog que muestre métricas relevantes de tu infraestructura AWS.

##4. Entrega:
* Crea una nueva rama en tu repositorio con tus iniciales
* Actualiza los archivos Terraform existentes y añade nuevos según sea necesario.
* Incluye un archivo README.md con:
	- Explicación de los cambios realizados.
	- Capturas de pantalla del dashboard y la alerta en Datadog.
	- Documentación de los prompts utilizados en datadog-aws-prompts.md.
	- Cualquier desafío encontrado y cómo lo resolviste.
* Crea un Pull Request con tus cambios.
* Recuerda que la lógica declarativa es muy sensible a cualquier información que le provees, asi que un gran prompt con muchos detalles podría hacer la diferencia para ti

##5. Documentación:
* En la carpeta prompts, crea un archivo "datadog-aws-prompts.md" donde documentes los prompts utilizados para generar el código Terraform relacionado con la integración Datadog-AWS.

##Notas:
Asegúrate de no compartir información sensible como claves API en tu código.

##Recursos Útiles:
- Documentación de Terraform para Datadog: https://registry.terraform.io/providers/DataDog/datadog/latest/docs
- Guía de inicio rápido de Datadog para AWS: https://docs.datadoghq.com/integrations/amazon_web_services/?tab=allpermissions
- Gestionando Datadog con Terraform: https://www.datadoghq.com/blog/managing-datadog-with-terraform/#deploy-datadog-with-terraform-today
- Configuración de AWS-Datadog con Terraform: https://docs.datadoghq.com/integrations/guide/aws-terraform-setup/
 
¡A por ello!