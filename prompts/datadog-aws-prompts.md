# Prompts para Integración Datadog-AWS con Terraform

Este documento contiene los prompts utilizados para generar el código Terraform relacionado con la integración Datadog-AWS en el proyecto AI4Devs-monitoring.

## Prompt 1: Configuración del Proveedor Datadog

**Prompt utilizado:**
```
Necesito configurar el proveedor Datadog en Terraform para mi proyecto de infraestructura AWS. 
El proyecto tiene instancias EC2 (backend y frontend) ejecutándose con Docker. 
Configura el proveedor Datadog con las siguientes características:
- Variables para API key y App key (sensibles)
- URL de API configurable (por defecto datadoghq.com)
- Integración con el proyecto existente
```

**Resultado:** Configuración del proveedor en `provider.tf` y variables en `variables.tf`

## Prompt 2: Integración AWS-Datadog

**Prompt utilizado:**
```
Crea la integración completa entre AWS y Datadog usando Terraform. 
Necesito:
- IAM role para Datadog con permisos completos de AWS
- Política de integración estándar de Datadog
- Política personalizada para métricas específicas (CloudWatch, EC2, RDS, S3, ELB)
- Configuración de filtros por tags
- External ID para seguridad
- Integración con el account ID actual de AWS
```

**Resultado:** Archivo `datadog.tf` con toda la configuración de integración

## Prompt 3: Instalación del Agente Datadog

**Prompt utilizado:**
```
Modifica los scripts de user_data de las instancias EC2 para instalar el agente Datadog.
Los scripts actuales instalan Docker y despliegan aplicaciones. 
Necesito agregar:
- Instalación automática del agente Datadog usando el script oficial
- Configuración del agente para monitorear Docker
- Variables de entorno para API key y site
- Reinicio del servicio después de la configuración
- Mantener la funcionalidad existente de Docker
```

**Resultado:** Modificación de `backend_user_data.sh` y `frontend_user_data.sh`

## Prompt 4: Dashboard de Monitoreo

**Prompt utilizado:**
```
Crea un dashboard completo en Datadog para monitorear la infraestructura AWS del proyecto LTI.
El dashboard debe incluir:
- Métricas de CPU y memoria de instancias EC2
- Métricas de red (tráfico entrante y saliente)
- Métricas de disco (lectura y escritura)
- Métricas de contenedores Docker
- Tiempo de respuesta de aplicaciones
- Widget de resumen con total de instancias
- Layout ordenado con widgets de 47x15
- Colores y estilos consistentes
- Leyendas habilitadas
```

**Resultado:** Dashboard completo en `datadog_dashboard.tf`

## Prompt 5: Monitores y Alertas

**Prompt utilizado:**
```
Crea monitores de alerta en Datadog para la infraestructura AWS:
- Alerta de CPU alta (>80% crítico, >70% warning)
- Alerta de memoria alta (>80% crítico, >70% warning)  
- Alerta de salud de contenedores Docker (contenedor no ejecutándose)
- Mensajes de escalación apropiados
- Umbrales de 5 minutos para evitar falsos positivos
- Tags incluidos en las alertas
- Configuración de no-data y renotificación
```

**Resultado:** Tres monitores de alerta en `datadog_dashboard.tf`

## Prompt 6: Configuración de Variables

**Prompt utilizado:**
```
Actualiza la configuración de Terraform para pasar las variables de Datadog a los scripts de user_data.
Necesito:
- Variables datadog_api_key y datadog_site en los templatefile
- Mantener la variable timestamp existente
- Aplicar a ambas instancias (backend y frontend)
- Formato correcto para templatefile de Terraform
```

**Resultado:** Actualización de `ec2.tf` con las variables necesarias

## Técnicas de Prompt Engineering Utilizadas

### 1. Contexto Específico
- Se proporcionó información detallada sobre la infraestructura existente
- Se especificaron los archivos y componentes involucrados
- Se mencionaron las tecnologías utilizadas (Docker, EC2, etc.)

### 2. Requisitos Claros
- Cada prompt especificaba exactamente qué se necesitaba
- Se incluyeron detalles técnicos específicos (umbrales, configuraciones)
- Se definieron los formatos de salida esperados

### 3. Integración con Código Existente
- Se consideró la estructura actual del proyecto
- Se mantuvieron las funcionalidades existentes
- Se especificó cómo integrar con el código actual

### 4. Detalles Técnicos
- Se incluyeron configuraciones específicas (puertos, rutas, comandos)
- Se especificaron valores por defecto apropiados
- Se consideraron aspectos de seguridad (variables sensibles)

### 5. Validación y Testing
- Se incluyeron configuraciones para evitar falsos positivos
- Se especificaron timeouts y delays apropiados
- Se consideraron escenarios de no-data

## Lecciones Aprendidas

1. **Especificidad es clave**: Los prompts más específicos generaron código más preciso
2. **Contexto completo**: Proporcionar información completa del proyecto mejora los resultados
3. **Requisitos técnicos**: Incluir detalles técnicos específicos evita configuraciones genéricas
4. **Integración**: Considerar el código existente es crucial para evitar conflictos
5. **Seguridad**: Especificar variables sensibles y configuraciones de seguridad desde el inicio

## Archivos Generados

- `provider.tf` - Configuración del proveedor Datadog
- `variables.tf` - Variables de configuración
- `datadog.tf` - Integración AWS-Datadog
- `datadog_dashboard.tf` - Dashboard y monitores
- `ec2.tf` - Actualizado con variables de Datadog
- `scripts/backend_user_data.sh` - Actualizado con agente Datadog
- `scripts/frontend_user_data.sh` - Actualizado con agente Datadog
