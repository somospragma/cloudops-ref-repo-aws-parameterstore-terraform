# Ejemplo básico de uso del módulo Parameter Store

# Configuración del provider con etiquetas por defecto
provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      environment = "dev"
      project     = "payments"
      owner       = "cloudops"
      client      = "pragma"
      area        = "infrastructure"
      provisioned = "terraform"
      datatype    = "operational"
    }
  }
}

# Uso del módulo Parameter Store
module "parameter_store" {
  source = "../../"

  client       = "pragma"
  functionality = "payments"
  environment  = "dev"

  parameter_store_config = {
    # Parámetro de configuración simple
    "app-version" = {
      type        = "String"
      value       = "1.0.0"
      description = "Versión actual de la aplicación de pagos"
    }
    
    # Parámetro sensible con cifrado
    "database-url" = {
      type        = "SecureString"
      value       = "postgresql://user:password@db.example.com:5432/payments"
      description = "URL de conexión a la base de datos de pagos"
      tier        = "Standard"
    }
    
    # Lista de endpoints
    "api-endpoints" = {
      type        = "StringList"
      value       = "https://api1.payments.com,https://api2.payments.com"
      description = "Lista de endpoints de API de pagos"
    }
    
    # Parámetro con etiquetas adicionales
    "feature-flags" = {
      type        = "String"
      value       = jsonencode({
        enable_new_ui = true
        enable_beta_features = false
      })
      description = "Configuración de feature flags en formato JSON"
      additional_tags = {
        service-tier = "standard"
        update-frequency = "weekly"
      }
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
  description = "Nombres de los parámetros creados"
  value       = module.parameter_store.parameter_names
}

output "parameter_hierarchy" {
  description = "Información de jerarquía de parámetros"
  value       = module.parameter_store.parameter_hierarchy
}
