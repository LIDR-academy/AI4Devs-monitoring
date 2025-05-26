# Prompts: Cursor + Claude Opus 4 (ask + agent mode)

**Prompt 1:**
Actúa como un experto en infraestructura como código y tecnologías de monitorización.

Analiza este proyecto completo de sistema ATS llamado "LTI" que utiliza tecnologías modernas como React, Express y Prisma. Revisa el archivo @README.md para comprender la arquitectura y los componentes del proyecto.

No generes código aún, únicamente familiarízate con la estructura y funcionalidades del sistema.

**Prompt 2:**
Basándote en el análisis previo del proyecto LTI, necesito implementar una solución de monitorización usando Datadog integrado con AWS a través de Terraform. El objetivo es extender la infraestructura existente para incluir dashboards de monitoreo automatizados.

Genera un plan detallado paso a paso considerando que:

- el repositorio ya está disponible localmente
- las credenciales AWS están configuradas,
- Terraform está instalado en el entorno de desarrollo.

**Prompt 3:**
Procede con la configuración inicial del entorno. Las credenciales de Datadog (API key y Application key) ya han sido obtenidas. Proporciona instrucciones específicas sobre cómo configurar correctamente las variables de entorno necesarias para la integración Terraform-Datadog.

**Prompt 4:**
La configuración del entorno está completa. Procede con la estructuración de archivos del proyecto. Verifica que la carpeta "prompts" y el archivo "datadog-aws-prompts.md" estén correctamente organizados. Identifica qué archivos adicionales son necesarios antes de proceder con la configuración de Terraform.

**Prompt 5:**
Implementa la configuración de Terraform para Datadog ejecutando las siguientes tareas: configuración del proveedor Datadog y definición de variables requeridas. Utiliza la información de credenciales proporcionada en el archivo de variables de entorno. Especifica qué configuraciones adicionales son necesarias para completar este proceso.

**Prompt 6:**
El comando `terraform init` se ejecutó exitosamente. Revisa la configuración de Terraform y procede con los siguientes pasos

**Prompt 7:**
Implementa la integración AWS-Datadog ejecutando las siguientes tareas:

- configuración del rol IAM para Datadog y configuración del agente Datadog en la instancia EC2. - Solicita cualquier información adicional requerida sobre las plataformas involucradas.

**Prompt 8:**
Actualiza el archivo terraform.tfvars con los valores correctos de Datadog basándote en la información de credenciales proporcionada. Confirma si la configuración es suficiente para proceder con la creación del dashboard.

**Prompt 9:**
Implementa la creación del dashboard en Datadog ejecutando las siguientes tareas: generación del dashboard de monitoreo y configuración de outputs de Terraform. Verifica que no se utilicen comandos deprecados basándote en los problemas identificados en fases anteriores. Asegura que la configuración sea funcional antes de proceder con el despliegue y verificación final.

**Prompt 10:**
Ejecuta el despliegue completo de la infraestructura con `terraform apply`. Una vez confirmado el despliegue exitoso, valida que el dashboard de Datadog esté funcionando correctamente y que las métricas de AWS se estén visualizando apropiadamente.

**Prompt 11:**
Genera un Pull Request completo para este proyecto incluyendo: título descriptivo sobre la implementación de monitorización con Datadog, descripción detallada de los cambios realizados, lista de archivos modificados/creados, instrucciones de testing y deployment, y checklist de validación. Incluye también capturas de pantalla del dashboard funcionando y cualquier consideración especial para el review del código de infraestructura.