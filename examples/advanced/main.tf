# Ejemplo avanzado con KMS personalizado y políticas

# Configuración del provider
provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      environment = "pdn"
      project     = "auth-service"
      owner       = "security-team"
      client      = "pragma"
      area        = "security"
      provisioned = "terraform"
      datatype    = "sensitive"
    }
  }
}

# Crear clave KMS personalizada para parámetros sensibles
resource "aws_kms_key" "parameter_store_key" {
  description             = "KMS key for Parameter Store encryption"
  deletion_window_in_days = 7
  
  tags = {
    Name = "pragma-auth-pdn-kms-parameter-store"
  }
}

resource "aws_kms_alias" "parameter_store_key_alias" {
  name          = "alias/pragma-auth-pdn-parameter-store"
  target_key_id = aws_kms_key.parameter_store_key.key_id
}

# Uso avanzado del módulo Parameter Store
module "parameter_store" {
  source = "../../"

  client       = "pragma"
  functionality = "auth-service"
  environment  = "pdn"

  parameter_store_config = {
    # Token JWT con expiración y validación de patrón
    "jwt-secret" = {
      type            = "SecureString"
      value           = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.secret.key"
      description     = "Clave secreta para firma de tokens JWT"
      tier            = "Advanced"
      kms_key_id      = aws_kms_key.parameter_store_key.arn
      allowed_pattern = "^[A-Za-z0-9+/=.-]{32,}$"
      additional_tags = {
        data-classification = "highly-confidential"
        rotation-required   = "true"
        compliance-level    = "pci-dss"
      }
    }
    
    # Credenciales de base de datos con tier avanzado
    "database-credentials" = {
      type        = "SecureString"
      value       = jsonencode({
        username = "auth_service_user"
        password = "super-secure-password-123!"
        host     = "auth-db.internal.pragma.com"
        port     = 5432
        database = "auth_production"
      })
      description = "Credenciales completas de base de datos en formato JSON"
      tier        = "Advanced"
      kms_key_id  = aws_kms_key.parameter_store_key.arn
      additional_tags = {
        service = "postgresql"
        backup-included = "true"
      }
    }
    
    # Configuración de OAuth con múltiples proveedores
    "oauth-providers" = {
      type        = "SecureString"
      value       = jsonencode({
        google = {
          client_id     = "google-client-id-123"
          client_secret = "google-client-secret-456"
        }
        microsoft = {
          client_id     = "microsoft-client-id-789"
          client_secret = "microsoft-client-secret-012"
        }
      })
      description = "Configuración de proveedores OAuth en formato JSON"
      tier        = "Advanced"
      kms_key_id  = aws_kms_key.parameter_store_key.arn
    }
    
    # Lista de URLs permitidas para CORS
    "cors-allowed-origins" = {
      type        = "StringList"
      value       = "https://app.pragma.com,https://admin.pragma.com,https://api.pragma.com"
      description = "Lista de orígenes permitidos para CORS"
      tier        = "Standard"
      additional_tags = {
        security-policy = "cors-whitelist"
      }
    }
    
    # Token temporal con patrón de validación
    "temp-access-token" = {
      type            = "SecureString"
      value           = "temp-token-abcdef123456"
      description     = "Token de acceso temporal para integraciones"
      tier            = "Standard"
      allowed_pattern = "^temp-token-[a-f0-9]{12}$"
      additional_tags = {
        expires-at = "2024-12-31"
        usage-type = "integration"
      }
    }
  }

  # Usar la clave KMS personalizada por defecto
  default_kms_key_id = aws_kms_key.parameter_store_key.arn
}

# Outputs detallados
output "all_parameter_info" {
  description = "Información completa de todos los parámetros"
  value = {
    arns     = module.parameter_store.parameter_arns
    names    = module.parameter_store.parameter_names
    versions = module.parameter_store.parameter_versions
    types    = module.parameter_store.parameter_types
  }
}

output "security_info" {
  description = "Información de seguridad de los parámetros"
  value = {
    secure_parameters        = module.parameter_store.secure_parameters
    kms_encrypted_parameters = module.parameter_store.kms_encrypted_parameters
    kms_key_arn             = aws_kms_key.parameter_store_key.arn
  }
}

output "parameter_hierarchy" {
  description = "Jerarquía de parámetros"
  value       = module.parameter_store.parameter_hierarchy
}
