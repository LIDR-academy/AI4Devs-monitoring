# Prompts para Generación de Código Terraform

## Prompt para Configuración de Proveedores

```
Genera un archivo main.tf de Terraform que configure los proveedores AWS y Datadog, incluyendo las variables necesarias para las claves de API.
```

## Prompt para Configuración de EC2

```
Crea un archivo ec2.tf que configure una instancia EC2 con:
- Security Group que permita SSH
- Script de usuario para instalar el agente de Datadog
- Tags apropiados
```

## Prompt para Dashboard de Datadog

```
Genera un archivo datadog.tf que cree un dashboard con:
- Gráfico de uso de CPU
- Gráfico de uso de memoria
- Gráfico de tráfico de red
Todos los gráficos deben usar las métricas de la instancia EC2 creada.
```

## Prompt para Outputs

```
Crea un archivo outputs.tf que muestre:
- La IP pública de la instancia EC2
- La URL del dashboard de Datadog
```

## Prompt para README

```
Crea un README.md que documente:
- Prerrequisitos
- Pasos de configuración
- Instrucciones de uso
- Componentes implementados
- Notas importantes
```

## Desafíos Encontrados y Soluciones

1. **Desafío: AMI ID no válido**
   - Problema: El AMI ID inicial no existía en la región us-east-1
   - Solución: Actualizado a un AMI válido de Amazon Linux 2023 (ami-0c7217cdde317cfec)
   - Prompt utilizado:
     ```
     Actualiza el AMI ID en ec2.tf con un ID válido de Amazon Linux 2023 en us-east-1
     ```

2. **Desafío: Dimensiones de widgets en Datadog**
   - Problema: Los widgets excedían el tamaño máximo del grid
   - Solución: Ajustado el layout para cumplir con las restricciones (máximo 12 unidades)
   - Prompt utilizado:
     ```
     Ajusta las dimensiones de los widgets en datadog.tf para que se ajusten al grid de 12 unidades
     ```

3. **Desafío: Atributo deprecado en Datadog**
   - Problema: El atributo is_read_only está deprecado
   - Solución: Eliminado el atributo y actualizada la configuración
   - Prompt utilizado:
     ```
     Actualiza la configuración del dashboard en datadog.tf eliminando el atributo is_read_only deprecado
     ```


## Pasos Adicionales Implementados

1. **Configuración de Credenciales**:
   - AWS: Configuración de Access Key y Secret Key
   - Datadog: Configuración de API Key y Application Key

2. **Verificación de Infraestructura**:
   - Comprobación del estado de Terraform
   - Verificación de recursos creados
   - Validación de conexiones y métricas

3. **Documentación**:
   - Actualización del README con capturas de pantalla
   - Documentación de desafíos y soluciones
   - Instrucciones de monitoreo y mantenimiento 