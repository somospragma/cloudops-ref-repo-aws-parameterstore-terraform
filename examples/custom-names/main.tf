# Ejemplo de uso con nombres personalizados

# Configuración del provider
provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      environment = "dev"
      project     = "analytics"
      owner       = "data-team"
      client      = "pragma"
      area        = "analytics"
      provisioned = "terraform"
      datatype    = "operational"
    }
  }
}

# Uso del módulo Parameter Store con nombres personalizados
module "parameter_store" {
  source = "../../"

  client       = "pragma"
  functionality = "analytics"
  environment  = "dev"

  parameter_store_config = {
    # Parámetro con nomenclatura estándar (sin custom_name)
    "standard-config" = {
      type        = "String"
      value       = "standard-value"
      description = "Parámetro con nomenclatura estándar"
    }
    
    # Parámetro con nombre personalizado
    "custom-analytics-db" = {
      type        = "SecureString"
      value       = "postgresql://analytics:password@db.analytics.com:5432/analytics"
      description = "Conexión a base de datos de analytics con nombre personalizado"
      custom_name = "/analytics/database/connection-string"
      tier        = "Standard"
    }
    
    # Otro parámetro con nombre personalizado para compatibilidad con sistemas legacy
    "legacy-api-key" = {
      type        = "SecureString"
      value       = "legacy-api-key-12345"
      description = "API Key para sistema legacy"
      custom_name = "/legacy/systems/api-key"
      additional_tags = {
        system-type = "legacy"
        migration-target = "new-analytics-api"
      }
    }
    
    # Parámetro con nombre personalizado para integración externa
    "external-service-config" = {
      type        = "String"
      value       = jsonencode({
        endpoint = "https://external-analytics.com/api"
        timeout  = 30
        retries  = 3
      })
      description = "Configuración para servicio externo de analytics"
      custom_name = "/external/analytics-service/config"
    }
    
    # Lista con nombre personalizado
    "data-sources" = {
      type        = "StringList"
      value       = "s3://analytics-bucket,redshift://analytics-cluster,rds://analytics-db"
      description = "Lista de fuentes de datos para analytics"
      custom_name = "/analytics/data-sources/list"
    }
  }

  # Usar clave KMS por defecto
  default_kms_key_id = "alias/aws/ssm"
}

# Outputs para mostrar los resultados
output "parameter_arns" {
  description = "ARNs de los parámetros creados"
  value       = module.parameter_store.parameter_arns
}

output "parameter_names" {
  description = "Nombres de los parámetros creados (estándar y personalizados)"
  value       = module.parameter_store.parameter_names
}

output "parameter_hierarchy" {
  description = "Información de jerarquía de parámetros"
  value       = module.parameter_store.parameter_hierarchy
}

# Output adicional para mostrar la diferencia entre nombres estándar y personalizados
output "naming_comparison" {
  description = "Comparación entre nomenclatura estándar y personalizada"
  value = {
    standard_would_be = {
      for key in keys(module.parameter_store.parameter_names) : 
      key => "/pragma/analytics/dev/${key}"
    }
    actual_names = module.parameter_store.parameter_names
  }
}
