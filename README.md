# Módulo Terraform - AWS SSM Parameter Store

Este módulo de Terraform permite crear y gestionar parámetros en AWS Systems Manager Parameter Store siguiendo los estándares de Pragma CloudOps.

## Características

- ✅ Nomenclatura estándar automática: `{client}-{project}-{environment}-ssm-{parameter_name}`
- ✅ Soporte para todos los tipos de parámetros (String, StringList, SecureString)
- ✅ Cifrado automático con KMS para parámetros sensibles
- ✅ Sistema de etiquetado estándar con soporte para etiquetas adicionales
- ✅ Jerarquía de parámetros organizada: `/{client}/{project}/{environment}/{parameter_name}`
- ✅ Soporte para políticas de parámetros (expiración, notificaciones)
- ✅ Validaciones de entrada para garantizar consistencia
- ✅ Outputs completos para integración con otros módulos

## Arquitectura

```
/{client}/{project}/{environment}/
├── parameter1 (String)
├── parameter2 (SecureString) [KMS Encrypted]
├── parameter3 (StringList)
└── ...
```

## Uso Básico

```hcl
module "parameter_store" {
  source = "./modules/parameter_store"

  client      = "pragma"
  project     = "payments"
  environment = "dev"

  parameter_store_config = {
    "database-url" = {
      type        = "SecureString"
      value       = "postgresql://user:pass@host:5432/db"
      description = "URL de conexión a la base de datos"
      tier        = "Standard"
    }
    
    "api-endpoints" = {
      type        = "StringList"
      value       = "https://api1.example.com,https://api2.example.com"
      description = "Lista de endpoints de API"
    }
    
    "app-version" = {
      type        = "String"
      value       = "1.0.0"
      description = "Versión actual de la aplicación"
      additional_tags = {
        service-tier = "standard"
        backup-policy = "none"
      }
    }
  }

  default_kms_key_id = "alias/pragma-payments-dev-kms"
}
```

## Uso Avanzado con Políticas

```hcl
module "parameter_store" {
  source = "./modules/parameter_store"

  client       = "pragma"
  functionality = "auth"
  environment  = "pdn"

  parameter_store_config = {
    "jwt-secret" = {
      type            = "SecureString"
      value           = "super-secret-jwt-key"
      description     = "Clave secreta para JWT"
      tier            = "Advanced"
      kms_key_id      = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      allowed_pattern = "^[A-Za-z0-9+/=]{32,}$"
      additional_tags = {
        data-classification = "highly-confidential"
        rotation-required   = "true"
      }
    }
  }

  parameter_policies = {
    "jwt-secret" = {
      policy_type = "Expiration"
      policy_text = jsonencode({
        Type = "Expiration"
        Version = "1.0"
        Attributes = {
          Timestamp = "2024-12-31T23:59:59.000Z"
        }
      })
    }
  }
}
```

## Variables

| Nombre | Descripción | Tipo | Requerido | Valor por Defecto |
|--------|-------------|------|-----------|-------------------|
| `client` | Nombre del cliente | `string` | ✅ | - |
| `project` | Proyecto al que pertenece el recurso | `string` | ✅ | - |
| `environment` | Entorno (dev/qa/pdn) | `string` | ✅ | - |
| `parameter_store_config` | Configuración de parámetros | `map(object)` | ✅ | - |
| `default_kms_key_id` | Clave KMS por defecto | `string` | ❌ | `alias/aws/ssm` |

### Configuración de Parámetros

Cada parámetro en `parameter_store_config` soporta:

| Atributo | Descripción | Tipo | Requerido | Valor por Defecto |
|----------|-------------|------|-----------|-------------------|
| `type` | Tipo de parámetro (String/StringList/SecureString) | `string` | ✅ | - |
| `value` | Valor del parámetro | `string` | ✅ | - |
| `description` | Descripción del parámetro | `string` | ❌ | `"Parameter managed by Terraform"` |
| `tier` | Tier del parámetro (Standard/Advanced/Intelligent-Tiering) | `string` | ❌ | `"Standard"` |
| `overwrite` | Permitir sobrescribir valores existentes | `bool` | ❌ | `true` |
| `allowed_pattern` | Patrón regex para validar valores | `string` | ❌ | `null` |
| `data_type` | Tipo de datos | `string` | ❌ | `"text"` |
| `kms_key_id` | Clave KMS específica para este parámetro | `string` | ❌ | `null` |
| `custom_name` | Nombre personalizado del parámetro (sobrescribe nomenclatura estándar) | `string` | ❌ | `null` |
| `additional_tags` | Etiquetas adicionales específicas | `map(string)` | ❌ | `{}` |

## Outputs

| Nombre | Descripción | Tipo |
|--------|-------------|------|
| `parameter_arns` | ARNs de todos los parámetros | `map(string)` |
| `parameter_names` | Nombres completos de los parámetros | `map(string)` |
| `parameter_versions` | Versiones de los parámetros | `map(number)` |
| `parameter_types` | Tipos de los parámetros | `map(string)` |
| `secure_parameters` | Lista de parámetros SecureString | `list(string)` |
| `parameter_hierarchy` | Información de jerarquía | `object` |
| `kms_encrypted_parameters` | Parámetros con KMS personalizado | `map(string)` |

## Ejemplos de Uso

### 1. Configuración de Base de Datos

```hcl
parameter_store_config = {
  "db-host" = {
    type        = "String"
    value       = "db.example.com"
    description = "Hostname de la base de datos"
  }
  
  "db-credentials" = {
    type        = "SecureString"
    value       = jsonencode({
      username = "dbuser"
      password = "dbpass123"
    })
    description = "Credenciales de base de datos en formato JSON"
    tier        = "Advanced"
  }
}
```

### 2. Configuración de API

```hcl
parameter_store_config = {
  "api-key" = {
    type            = "SecureString"
    value           = "sk-1234567890abcdef"
    description     = "Clave de API externa"
    allowed_pattern = "^sk-[a-f0-9]{16}$"
    additional_tags = {
      service = "external-api"
      rotation-schedule = "monthly"
    }
  }
  
  "endpoints" = {
    type        = "StringList"
    value       = "https://api.service1.com,https://api.service2.com"
    description = "Lista de endpoints de servicios externos"
  }
}
```

### 4. Configuración con Nombres Personalizados

```hcl
parameter_store_config = {
  # Parámetro con nomenclatura estándar
  "standard-config" = {
    type        = "String"
    value       = "standard-value"
    description = "Parámetro con nomenclatura estándar"
    # Resultado: /pragma/analytics/dev/standard-config
  }
  
  # Parámetro con nombre personalizado
  "custom-db-config" = {
    type        = "SecureString"
    value       = "postgresql://user:pass@host:5432/db"
    description = "Configuración de base de datos con nombre personalizado"
    custom_name = "/analytics/database/connection-string"
    # Resultado: /analytics/database/connection-string
  }
  
  # Parámetro para compatibilidad con sistemas legacy
  "legacy-api-key" = {
    type        = "SecureString"
    value       = "legacy-key-12345"
    description = "API Key para sistema legacy"
    custom_name = "/legacy/systems/api-key"
    additional_tags = {
      system-type = "legacy"
      migration-target = "new-api"
    }
  }
}
```

## Integración con Provider Tags

Este módulo está diseñado para trabajar con `default_tags` del provider AWS:

```hcl
provider "aws" {
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
```

## Seguridad

- **Cifrado en reposo**: Todos los parámetros `SecureString` se cifran automáticamente con KMS
- **Cifrado personalizado**: Soporte para claves KMS específicas por parámetro
- **Validación de patrones**: Validación regex opcional para valores de parámetros
- **Políticas de acceso**: Soporte para políticas de expiración y notificaciones
- **Etiquetado de seguridad**: Etiquetas para clasificación de datos y políticas de acceso

## Mejores Prácticas

1. **Jerarquía de parámetros**: Usa nombres descriptivos que reflejen la estructura organizacional
2. **Tipos apropiados**: Usa `SecureString` para datos sensibles, `StringList` para listas
3. **Descripciones claras**: Proporciona descripciones detalladas para cada parámetro
4. **Cifrado KMS**: Usa claves KMS específicas para datos altamente sensibles
5. **Políticas de expiración**: Implementa políticas de expiración para tokens temporales
6. **Etiquetado consistente**: Usa etiquetas adicionales para clasificación y gestión

## Requisitos

- Terraform >= 1.0
- AWS Provider >= 5.0
- Permisos IAM para SSM Parameter Store y KMS

## Permisos IAM Requeridos

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:PutParameter",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:DeleteParameter",
        "ssm:DescribeParameters",
        "ssm:PutParameterPolicy",
        "ssm:GetParameterPolicy",
        "ssm:DeleteParameterPolicy"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
```

## Versionado

Este módulo sigue el versionado semántico (MAJOR.MINOR.PATCH):
- **MAJOR**: Cambios incompatibles en la API
- **MINOR**: Nuevas funcionalidades compatibles hacia atrás
- **PATCH**: Correcciones de errores compatibles hacia atrás

## Contribución

Para contribuir a este módulo:
1. Sigue los estándares de Pragma CloudOps
2. Incluye pruebas para nuevas funcionalidades
3. Actualiza la documentación
4. Asegúrate de que el código pase todas las validaciones

## Soporte

Para soporte técnico o preguntas sobre este módulo, contacta al equipo de CloudOps de Pragma.
