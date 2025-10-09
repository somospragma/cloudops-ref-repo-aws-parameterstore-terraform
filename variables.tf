# Variables estándar del módulo
variable "client" {
  description = "Nombre del cliente para el que se crea el recurso"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.client))
    error_message = "El cliente debe contener solo letras minúsculas, números y guiones."
  }
}

variable "project" {
  description = "Proyecto al que pertenece el recurso"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "El proyecto debe contener solo letras minúsculas, números y guiones."
  }
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  validation {
    condition     = contains(["dev", "qa", "pdn", "prod"], var.environment)
    error_message = "El entorno debe ser uno de: dev, qa, pdn, prod."
  }
}

# Configuración de parámetros
variable "parameter_store_config" {
  description = "Configuración de parámetros de SSM Parameter Store"
  type = map(object({
    type            = string
    value           = string
    description     = optional(string, "Parameter managed by Terraform")
    tier            = optional(string, "Standard")
    overwrite       = optional(bool, true)
    allowed_pattern = optional(string, null)
    data_type       = optional(string, "text")
    kms_key_id      = optional(string, null)
    custom_name     = optional(string, null)
    additional_tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for k, v in var.parameter_store_config : contains(["String", "StringList", "SecureString"], v.type)
    ])
    error_message = "El tipo de parámetro debe ser uno de: String, StringList, SecureString."
  }

  validation {
    condition = alltrue([
      for k, v in var.parameter_store_config : contains(["Standard", "Advanced", "Intelligent-Tiering"], v.tier)
    ])
    error_message = "El tier debe ser uno de: Standard, Advanced, Intelligent-Tiering."
  }
}

# KMS Key para cifrado por defecto
variable "default_kms_key_id" {
  description = "ID de la clave KMS por defecto para cifrar parámetros SecureString"
  type        = string
  default     = "alias/aws/ssm"
}

