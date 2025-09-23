# ✍️ Ejercicio: Implementando un Canal de Monitorización Datadog🐶 con Terraform en AWS 🔴

## 🎯 **Resumen del Proyecto**

Este documento describe la implementación completa de un canal de monitorización con Datadog en AWS usando Terraform, incluyendo la instalación del Datadog Agent en instancias EC2, configuración de dashboards, alertas y procesamiento de logs.

---

## 📋 **Cambios Realizados**

### **1. Configuración de Infraestructura**
- **Integración AWS-Datadog**: Configurada mediante Terraform con políticas IAM optimizadas para capa gratuita
- **Variables de entorno**: Todas las credenciales sensibles movidas a archivo `.env`
- **Optimización de costos**: Configuración específica para evitar cargos innecesarios

### **2. Instalación del Datadog Agent**
- **Scripts automatizados**: Creados scripts de instalación para backend y frontend
- **Configuración personalizada**: Agente configurado con tags específicos y monitoreo de Docker
- **Health checks**: Implementados scripts de verificación de salud de las aplicaciones

### **3. Dashboards y Monitoreo**
- **Dashboard principal**: "LTI Application - Infrastructure & Performance"
- **Monitores críticos**: CPU, memoria, disco, Datadog Agent y contenedores Docker
- **Log pipelines**: Configurados para procesar logs de backend y frontend

### **4. Documentación y Operaciones**
- **Runbook**: Guía completa para respuesta a incidentes
- **Scripts de validación**: Automatización de verificación de la integración
- **Documentación técnica**: Estado detallado de implementación

---

## 📸 **Capturas de Pantalla**

### **1. Dashboard Principal - LTI Application**
<!-- Para visualización local: ../docs/screenshots/dashboard principal.png -->
![Dashboard Principal](https://raw.githubusercontent.com/aandmaldonado/AI4Devs-monitoring/feature-alvaro-maldonado/docs/screenshots/dashboard%20principal.png)
*Dashboard "LTI Application - Infrastructure & Performance" con métricas en tiempo real*
*URL: https://app.datadoghq.eu/dashboard/md4-4ty-jxk*

### **2. Lista de Monitores Configurados**
![Lista de Monitores](https://raw.githubusercontent.com/aandmaldonado/AI4Devs-monitoring/feature-alvaro-maldonado/docs/screenshots/monitor%20list.png)
*Configuración detallada de monitores y alertas en Datadog*

### **3. Integración AWS-Datadog**
![Integración AWS](https://raw.githubusercontent.com/aandmaldonado/AI4Devs-monitoring/feature-alvaro-maldonado/docs/screenshots/integracion%20aws.png)
*Estado de la integración AWS-Datadog y métricas recopiladas*

### **4. Host Map - Vista de Infraestructura**
![Host Map](https://raw.githubusercontent.com/aandmaldonado/AI4Devs-monitoring/feature-alvaro-maldonado/docs/screenshots/host%20map.png)
*Vista de infraestructura con métricas de CPU, memoria y disco por host*

### **5. Lista de Hosts Monitoreados**
![Lista de Hosts](https://raw.githubusercontent.com/aandmaldonado/AI4Devs-monitoring/feature-alvaro-maldonado/docs/screenshots/host%20list.png)
*Lista de hosts (backend y frontend) monitoreados en Datadog*

### **6. Instancia EC2 - Backend**
![Instancia EC2 Backend](https://raw.githubusercontent.com/aandmaldonado/AI4Devs-monitoring/feature-alvaro-maldonado/docs/screenshots/instancia%20EC2-1.png)
*Detalles de la instancia EC2 del backend con métricas específicas*

### **7. Instancia EC2 - Frontend**
![Instancia EC2 Frontend](https://raw.githubusercontent.com/aandmaldonado/AI4Devs-monitoring/feature-alvaro-maldonado/docs/screenshots/instancia%20EC2-2.png)
*Detalles de la instancia EC2 del frontend con métricas específicas*

---

## 📝 **Documentación de Prompts Utilizados**

Los siguientes prompts fueron utilizados durante la implementación, documentados en `datadog-aws-prompts-AMP.md`:

### **Prompt 1: Análisis Inicial**
```
Eres un Cloud Engineer experto en AWS, terraform y datadog. Revisa @init-AMP.md analiza el requerimiento descrito y crea un nuevo archivo con el plan de trabajo para que pueda ser implementado satisfactoriamente por un rol devsecops.
```

### **Prompt 2: Implementación Fase a Fase**
```
Eres un devsecops experto en AWS, Terraform y datadog. Sigue los lineamientos de @datadog-aws-implementation-plan-AMP.md para la implementación de Observabilidad con Datadog en AWS usando Terraform. Ejecuta fase a fase, no realices todas las tareas de una sola vez.
```

### **Prompt 3: Gestión de Variables**
```
Analiza @init.md y agrega todas las variables de entorno necesarias que deberian estar en /.env
```

### **Prompt 4: Integración AWS-Datadog**
```
cree la integracion entre AWS y datadog mediante terraform y necesito aplicar esto:
@provider.tf
```

### **Prompt 5: Configuración de URL**
```
necesito que todo lo q comentaste en @provider.tf funcione, para cerrar la integracion de datadog . la url es @https://app.datadoghq.eu/
```

### **Prompt 6: Seguridad de Credenciales**
```
todas las variables obtenlas de .env no puede quedar nada sensible en los archivos que subire al repo
```

### **Prompt 7: Validación de Seguridad**
```
valida nuevamente que no haya ningun key expuesta apra subir al repo
```

### **Prompt 8: Verificación Manual**
```
necesitas que genere algo manualmente en las consolas de AWS o datadog? antes de proceder con la siguiente fase?
```

### **Prompt 9: Optimización de Costos**
```
Procede con la Fase 2 para optimizar costos y capa gratuita. Aplicar estas optimizaciones con terraform apply
```

### **Prompt 10: Instalación de Agentes**
```
Procede con la Fase 3: Instalación del Datadog Agent en las instancias EC2. Aplica cambios a instancias existentes: Recrear las instancias EC2 con los nuevos scripts.
```

### **Prompt 11: Scripts de Instalación**
```
dame el script para q lo ejecute en las instancias
```

### **Prompt 12: Dashboards y Monitoreo**
```
Continua con la Fase 4: Dashboards y Monitoreo
```

### **Prompt 13: Revisión Final**
```
Revisa el Checklist de Implementación en @datadog-aws-implementation-plan-AMP.md y ve si falta algo por realizar
```

---

## 🚧 **Desafíos Encontrados y Soluciones**

### **1. Problema: Autenticación de Datadog**
**Desafío**: Error de autenticación con el proveedor de Datadog
**Solución**: 
- Configuración correcta de la URL de la API (`https://api.datadoghq.eu/`)
- Validación de claves API y APP
- Uso de variables de entorno para credenciales sensibles

### **2. Problema: Instalación de Datadog Agent en EC2**
**Desafío**: Scripts de instalación no funcionaban correctamente en instancias existentes
**Solución**:
- Creación de scripts específicos para cada instancia (backend/frontend)
- Configuración manual mediante SSH
- Implementación de health checks automatizados

### **3. Problema: Configuración de Monitores**
**Desafío**: Errores de sintaxis en queries de monitores
**Solución**:
- Corrección de comillas simples por dobles en queries
- Ajuste de umbrales para monitores de tipo service check
- Validación de sintaxis con `terraform validate`

### **4. Problema: Optimización de Costos**
**Desafío**: Evitar cargos por servicios no necesarios en capa gratuita
**Solución**:
- Configuración de `free_tier_optimized = true`
- Exclusión de namespaces costosos (SQS, Lambda, ECS, etc.)
- Deshabilitación de recolección extendida y CSPM

### **5. Problema: Procesamiento de Logs**
**Desafío**: Errores de sintaxis en pipelines de logs
**Solución**:
- Recreación completa del archivo `datadog-logs.tf`
- Simplificación de procesadores Grok
- Validación de configuración YAML

---

## 🔧 **Instrucciones de Instalación**

### **Método 1: Scripts Automatizados**

#### **Para Backend:**
```bash
# Conectarse a la instancia
ssh -i tu-clave.pem ec2-user@54.242.188.99

# Ejecutar script de instalación
curl -s https://raw.githubusercontent.com/DataDog/datadog-agent/main/cmd/agent/install_script.sh | DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=YOUR_DATADOG_API_KEY DD_SITE=datadoghq.eu bash
```

#### **Para Frontend:**
```bash
# Conectarse a la instancia
ssh -i tu-clave.pem ec2-user@54.161.33.52

# Ejecutar script de instalación
curl -s https://raw.githubusercontent.com/DataDog/datadog-agent/main/cmd/agent/install_script.sh | DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=YOUR_DATADOG_API_KEY DD_SITE=datadoghq.eu bash
```

### **Método 2: Scripts Personalizados**

Los scripts completos están disponibles en:
- `tf/scripts/backend-install-datadog.sh`
- `tf/scripts/frontend-install-datadog.sh`

---

## ✅ **Verificaciones Post-Instalación**

```bash
# Verificar estado del Datadog Agent
sudo systemctl status datadog-agent

# Ver logs del agente
sudo tail -f /var/log/datadog-agent/agent.log

# Ejecutar health check
sudo /usr/local/bin/backend-health-check.sh  # Para backend
sudo /usr/local/bin/frontend-health-check.sh # Para frontend
```

---

## 🎯 **Resultados Esperados**

Después de la implementación completa:

✅ **2 hosts monitoreados** (backend-i-xxx, frontend-i-xxx)  
✅ **Dashboard activo** con métricas en tiempo real  
✅ **6 monitores configurados** para alertas críticas  
✅ **Logs procesados** y indexados  
✅ **Documentación completa** para operaciones  
✅ **Scripts de validación** automatizados  

---

## 📊 **Accesos Directos**

- **Dashboard Datadog**: https://app.datadoghq.eu/dashboard/md4-4ty-jxk
- **Backend EC2**: 54.242.188.99
- **Frontend EC2**: 54.161.33.52
- **S3 Bucket**: ai4devs-project-code-bucket-7dd154b1

---

## 📚 **Documentación Adicional**

- **Capturas de Pantalla**: `../docs/screenshots/` - Evidencia visual de la implementación
- **Plan de Implementación**: `prompts/datadog-aws-implementation-plan-AMP.md`
- **Historial de Prompts**: `prompts/datadog-aws-prompts-AMP.md`
- **Configuración de Variables**: `tf/terraform.tfvars.example`
- **Template de Variables de Entorno**: `env.template`
