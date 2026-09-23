Prompt 0
IA: ChatGPT

Un prompt para Cursor, el cual haga lo siguiente: Un script para hacer lo siguiente: En este ejercicio, ampliaremos nuestro proyecto de infraestructura como código utilizando Terraform para implementar un canal de monitorización de Datadog en AWS. Aprovecharemos técnicas de prompt engineering para automatizar la generación de código, lo que nos permitirá monitorear y obtener insights valiosos de nuestra infraestructura AWS de manera automatizada. 1 Configuracion Inicial: Asegurate de tener configuradas tus credenciales de AWS y Datadog en tu entorno Revisa el código terraform generado en el ejercicio anterior. 2 Objetivo del Ejercicio: Tu misión es extender el código Terraform existente para: Configurar la integración de Datadog con AWS usando Terraform. Instalar el agente Datadog en la instancia EC2. Crear un dashboard en Datadog para visualizar métricas clave de AWS. 3 Pasos a Seguir: a) Configurar la Integración AWS–Datadog: Utiliza Terraform para configurar la integración entre AWS y Datadog, siguiendo la guía proporcionada. b) Configurar el Proveedor Datadog: Añade el proveedor Datadog a tu configuración de Terraform. c) Instalar el Agente Datadog: Modifica el script de usuario de la instancia EC2 para instalar y configurar el agente Datadog. d) Crear un Dashboard: Utiliza Terraform para definir un dashboard en Datadog que muestre métricas relevantes de tu infraestructura AWS. 4 Entrega: Crea una nueva rama en tu repositorio con tus iniciales. Actualiza los archivos Terraform existentes y añade nuevos según sea necesario. Incluye un archivo README.md con: Explicación de los cambios realizados. Capturas de pantalla del dashboard y la alerta en Datadog. Documentación de los prompts utilizados en datadog-aws-prompts.md. Cualquier desafío encontrado y cómo lo resolviste. Crea un Pull Request con tus cambios. Recuerda que la lógica declarativa es muy sensible a cualquier información que le provees, así que un gran prompt con muchos detalles podría hacer la diferencia para ti. 5 Documentación: En la carpeta prompts, crea un archivo datadog-aws-prompts.md donde documentes los prompts utilizados para generar el código Terraform relacionado con la integración Datadog–AWS. Actualmente cuento con las cuentas de AWS y Datadog, indicame como extraer las credenciales que necesito para colocarlas en el script


Prompt 1
IA: Cursor
Actúa como un Senior DevOps Engineer experto en Terraform, AWS y Datadog. 

Contexto:
Tengo un proyecto de Infraestructura como Código ya existente en Terraform que despliega recursos en AWS (incluye al menos una instancia EC2). Necesito extender este proyecto para implementar un canal completo de monitoreo utilizando Datadog en AWS.

Scripts terraform @tf 

Objetivo:
Generar el código Terraform necesario para:

1. Configurar la integración entre AWS y Datadog usando Terraform.
2. Añadir y configurar el provider oficial de Datadog.
3. Instalar y configurar el agente Datadog en la instancia EC2 mediante user_data.
4. Crear un dashboard en Datadog que muestre métricas clave de AWS.
5. (Opcional pero recomendado) Crear al menos una alerta (monitor) en Datadog sobre una métrica crítica.

Requisitos técnicos:

1️⃣ Configuración Inicial
- Asume que ya tengo cuentas activas en AWS y Datadog.
- Indica explícitamente qué credenciales necesito:
  - AWS: Access Key ID y Secret Access Key.
  - Datadog: API Key y Application Key.
- Explica paso a paso cómo obtener:
  - AWS Access Key desde IAM.
  - Datadog API Key y Application Key desde la consola de Datadog.
- Indica cómo exportarlas como variables de entorno:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - DATADOG_API_KEY
  - DATADOG_APP_KEY

2️⃣ Terraform – Integración AWS–Datadog
- Usa el provider oficial de Datadog.
- Configura la integración aws en Datadog usando recursos Terraform.
- Crea los recursos IAM necesarios (role + policy + trust relationship) para permitir que Datadog lea métricas desde AWS.
- Usa buenas prácticas:
  - Variables para region, account_id, environment.
  - Outputs relevantes.
  - Separación modular si es posible.

3️⃣ Instalación del Agente Datadog en EC2
- Modifica el user_data del recurso aws_instance.
- Incluye script bash completo para:
  - Instalar el agente.
  - Configurar la API Key.
  - Habilitar logs si aplica.
  - Iniciar el servicio.
- Usa interpolación segura para la API Key (variable).

4️⃣ Dashboard en Datadog
- Crea un recurso datadog_dashboard.
- Incluye widgets como:
  - CPU utilization (EC2)
  - Network in/out
  - Status de instancia
  - Métricas básicas de infraestructura
- Usa un layout limpio y bien estructurado.

5️⃣ Monitor (Alerta)
- Crea al menos un recurso datadog_monitor.
- Ejemplo: alerta si CPU > 80% por 5 minutos.
- Incluye mensaje de notificación claro.

6️⃣ Entrega del Proyecto
El código generado debe contemplar:

- Nueva rama con mis iniciales.
- Actualización de archivos Terraform existentes.
- Archivos nuevos si son necesarios (providers.tf, variables.tf, dashboard.tf, monitor.tf, etc).
- README.md que incluya:
  - Explicación de cambios.
  - Pasos para ejecutar (terraform init/plan/apply).
  - Dónde obtener capturas del dashboard y alerta.
  - Problemas encontrados y soluciones.
- Archivo prompts/datadog-aws-prompts.md documentando los prompts utilizados para generar el código.

Formato de respuesta esperado:
- Estructura clara de archivos.
- Código completo listo para copiar y ejecutar.
- Explicaciones técnicas breves pero claras.
- Buenas prácticas de Terraform.
- Sin omitir bloques necesarios.

Prioriza:
- Seguridad
- Modularidad
- Legibilidad
- Buenas prácticas DevOps
- Código listo para producción