#!/bin/bash
# Script para desplegar la infraestructura completa

echo "🚀 Desplegando infraestructura AI4Devs-monitoring con Datadog..."

# Validar configuración
echo "📋 Validando configuración de Terraform..."
terraform validate

if [ $? -eq 0 ]; then
    echo "✅ Configuración válida"
    
    # Mostrar plan
    echo "📋 Mostrando plan de despliegue..."
    terraform plan
    
    echo ""
    echo "⚠️  IMPORTANTE: Revisa el plan antes de continuar"
    echo "💡 Para aplicar los cambios ejecuta: terraform apply"
    echo ""
    
else
    echo "❌ Error en la configuración de Terraform"
    exit 1
fi