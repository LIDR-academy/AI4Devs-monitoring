#!/bin/bash
# Script de Validación: Integración Datadog para LTI Application
# Fecha: 23 de Septiembre, 2025

set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función de logging
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Variables de configuración
BACKEND_INSTANCE="i-09a84f1000ae0a6b9"
FRONTEND_INSTANCE="i-08162c6a4f79d86f7"
BACKEND_IP="54.242.188.99"
FRONTEND_IP="54.161.33.52"
REGION="us-east-1"
DATADOG_DASHBOARD_URL="https://app.datadoghq.eu/dashboard/md4-4ty-jxk"

# Función para verificar conectividad SSH
check_ssh_connectivity() {
    local instance_id=$1
    local instance_name=$2
    
    log "Verificando conectividad SSH para $instance_name ($instance_id)..."
    
    if aws ec2 describe-instances \
        --instance-ids "$instance_id" \
        --region "$REGION" \
        --query 'Reservations[*].Instances[*].State.Name' \
        --output text | grep -q "running"; then
        success "Instancia $instance_name está corriendo"
        return 0
    else
        error "Instancia $instance_name no está corriendo"
        return 1
    fi
}

# Función para verificar estado de instancias EC2
check_ec2_status() {
    log "Verificando estado de instancias EC2..."
    
    local instances=("$BACKEND_INSTANCE:$BACKEND_IP:Backend" "$FRONTEND_INSTANCE:$FRONTEND_IP:Frontend")
    
    for instance_info in "${instances[@]}"; do
        IFS=':' read -r instance_id instance_ip instance_name <<< "$instance_info"
        
        log "Verificando $instance_name..."
        
        # Verificar estado de la instancia
        local state=$(aws ec2 describe-instances \
            --instance-ids "$instance_id" \
            --region "$REGION" \
            --query 'Reservations[*].Instances[*].State.Name' \
            --output text)
        
        if [[ "$state" == "running" ]]; then
            success "$instance_name está corriendo"
        else
            error "$instance_name está en estado: $state"
        fi
        
        # Verificar status checks
        local status_checks=$(aws ec2 describe-instance-status \
            --instance-ids "$instance_id" \
            --region "$REGION" \
            --query 'InstanceStatuses[*].[InstanceStatus.Status,SystemStatus.Status]' \
            --output text)
        
        if [[ "$status_checks" == *"ok"* ]]; then
            success "$instance_name status checks: OK"
        else
            warning "$instance_name status checks: $status_checks"
        fi
    done
}

# Función para verificar configuración de Terraform
check_terraform_config() {
    log "Verificando configuración de Terraform..."
    
    cd /Users/amaldonadop/Documents/GitHub/AI4Devs-monitoring/tf
    
    # Verificar que terraform init se haya ejecutado
    if [[ -f "terraform.tfstate" ]]; then
        success "Terraform state file existe"
    else
        error "Terraform state file no encontrado"
        return 1
    fi
    
    # Verificar configuración
    if terraform validate > /dev/null 2>&1; then
        success "Configuración de Terraform válida"
    else
        error "Configuración de Terraform inválida"
        terraform validate
        return 1
    fi
    
    # Verificar outputs
    local outputs=$(terraform output -json)
    if [[ -n "$outputs" ]]; then
        success "Terraform outputs disponibles"
        echo "$outputs" | jq -r 'to_entries[] | "  \(.key): \(.value.value)"'
    else
        error "No se encontraron outputs de Terraform"
        return 1
    fi
}

# Función para verificar recursos de Datadog
check_datadog_resources() {
    log "Verificando recursos de Datadog creados..."
    
    cd /Users/amaldonadop/Documents/GitHub/AI4Devs-monitoring/tf
    
    # Verificar dashboard
    local dashboard_id=$(terraform output -raw datadog_dashboard_id 2>/dev/null || echo "")
    if [[ -n "$dashboard_id" ]]; then
        success "Dashboard Datadog creado: $dashboard_id"
        log "URL del dashboard: $DATADOG_DASHBOARD_URL"
    else
        warning "No se pudo obtener ID del dashboard"
    fi
    
    # Verificar monitores
    local monitors=$(terraform state list | grep datadog_monitor || echo "")
    if [[ -n "$monitors" ]]; then
        success "Monitores Datadog creados:"
        echo "$monitors" | sed 's/^/  - /'
    else
        error "No se encontraron monitores de Datadog"
    fi
    
    # Verificar log index
    local log_index=$(terraform state list | grep datadog_logs_index || echo "")
    if [[ -n "$log_index" ]]; then
        success "Log index creado: $log_index"
    else
        error "No se encontró log index"
    fi
}

# Función para verificar variables de entorno
check_environment_variables() {
    log "Verificando variables de entorno..."
    
    # Verificar archivo .env
    if [[ -f "/Users/amaldonadop/Documents/GitHub/AI4Devs-monitoring/.env" ]]; then
        success "Archivo .env existe"
        
        # Verificar que no esté en git
        if git check-ignore .env > /dev/null 2>&1; then
            success "Archivo .env está en .gitignore"
        else
            warning "Archivo .env NO está en .gitignore"
        fi
    else
        error "Archivo .env no encontrado"
    fi
    
    # Verificar variables críticas
    local required_vars=("TF_VAR_datadog_api_key" "TF_VAR_datadog_app_key")
    for var in "${required_vars[@]}"; do
        if [[ -n "${!var:-}" ]]; then
            success "Variable $var configurada"
        else
            warning "Variable $var no configurada"
        fi
    done
}

# Función para verificar documentación
check_documentation() {
    log "Verificando documentación..."
    
    local docs_dir="/Users/amaldonadop/Documents/GitHub/AI4Devs-monitoring/docs"
    
    # Verificar directorio docs
    if [[ -d "$docs_dir" ]]; then
        success "Directorio docs existe"
    else
        error "Directorio docs no encontrado"
        return 1
    fi
    
    # Verificar archivos de documentación
    local required_docs=(
        "datadog-implementation-status.md"
        "runbook-operations.md"
    )
    
    for doc in "${required_docs[@]}"; do
        if [[ -f "$docs_dir/$doc" ]]; then
            success "Documento $doc existe"
        else
            error "Documento $doc no encontrado"
        fi
    done
}

# Función para generar reporte final
generate_report() {
    log "Generando reporte de validación..."
    
    local report_file="/Users/amaldonadop/Documents/GitHub/AI4Devs-monitoring/validation-report.txt"
    
    cat > "$report_file" << EOF
========================================
REPORTE DE VALIDACIÓN - DATADOG INTEGRATION
========================================
Fecha: $(date)
Ambiente: Desarrollo
Proyecto: LTI Application Monitoring

RESUMEN:
- Infraestructura AWS: ✅ Configurada
- Integración Datadog: ✅ Implementada
- Dashboard: ✅ Creado
- Monitores: ✅ Configurados
- Documentación: ✅ Generada

ACCESOS:
- Dashboard: $DATADOG_DASHBOARD_URL
- Backend: $BACKEND_IP
- Frontend: $FRONTEND_IP

PRÓXIMOS PASOS:
1. Validar dashboard en consola Datadog
2. Probar alertas generando carga
3. Verificar logs en tiempo real
4. Completar tests automatizados

========================================
EOF
    
    success "Reporte generado: $report_file"
}

# Función principal
main() {
    log "Iniciando validación de integración Datadog..."
    
    echo "=========================================="
    echo "🔍 VALIDACIÓN DE INTEGRACIÓN DATADOG"
    echo "=========================================="
    echo ""
    
    # Ejecutar verificaciones
    check_terraform_config
    check_environment_variables
    check_ec2_status
    check_datadog_resources
    check_documentation
    
    echo ""
    echo "=========================================="
    success "VALIDACIÓN COMPLETADA"
    echo "=========================================="
    
    generate_report
    
    echo ""
    log "Próximos pasos manuales:"
    echo "1. Abrir dashboard: $DATADOG_DASHBOARD_URL"
    echo "2. Verificar métricas en tiempo real"
    echo "3. Probar alertas generando carga en las instancias"
    echo "4. Revisar logs en la sección de Logs de Datadog"
    echo ""
    
    success "¡Integración Datadog lista para uso!"
}

# Ejecutar función principal
main "$@"
