# Plan de Implementación: Monitorización AWS-Datadog

## Fase 1: Cimientos y Seguridad [COMPLETED]
- [x] Configuración inicial del entorno (Memory Bank & Rules).
- [x] Gestión de secretos (terraform.tfvars).
- [x] Configuración del Provider Datadog en Terraform.
- [x] Implementación de la Integración AWS-Datadog (IAM Roles y Trust Relationship).
- [x] Recurso `datadog_integration_aws` vinculando cuenta AWS con Datadog.
- [x] Refactorización S3: aws_s3_object (eliminando deprecations).

## Fase 2: Despliegue de Infraestructura y Agente [COMPLETED]
- [x] Modificación de la instancia EC2 existente (User Data configurado).
- [x] Inyección de Datadog Agent vía User Data (Script de instalación).
- [x] Verificación de conectividad de red (Security Groups + VPC por defecto).
- [x] Ejecución de `terraform apply` (17 recursos creados exitosamente).
- [x] Resolución de conflicto S3 bucket (nombre único con account_id).
- [x] Auditoría de configuración del agente (API key, site, conectividad).
- [x] Corrección de región: DD_SITE="datadoghq.eu" + tags + hostnames.
- [x] Re-ejecución de terraform apply para actualizar instancias EC2.
- [ ] Verificación de reporte de métricas en consola EU (5-10 min tras apply).

## Fase 3: Visualización y Alertas [COMPLETED]
- [x] Definición del recurso `datadog_dashboard` en Terraform.
- [x] Creación de archivo dashboard.tf con 6 secciones de widgets.
- [x] Configuración de métricas: CPU, Memory, Disk I/O, Network, Load, Host Map.
- [x] Implementación de Query Values para valores actuales.
- [x] Configuración de filtros por tags (project:lti-monitoring).
- [x] Ejecución de `terraform apply` para crear el dashboard en EU.
- [x] Verificación del dashboard en consola Datadog EU.
- [x] Validación de widgets y métricas en tiempo real.
- [x] (Opcional) Configuración de monitores/alertas.

## Fase 4: Cierre y Entrega [COMPLETED]
- [x] Documentación técnica profesional (README.md con 8 secciones).
- [x] Unificación de READMEs (monitorización + aplicación LTI).
- [x] Migración de historial de prompts (datadog-aws-prompts.md).
- [x] Sincronización completa del Memory Bank.
- [x] Auditoría de seguridad (0 secretos expuestos).
- [x] Preparación de comandos Git y nota de entrega.
- [x] Capturas de pantalla (Host Map, Dashboard, métricas).
- [x] Creación del Pull Request (Usuario).
