# Outputs del módulo Parameter Store

output "parameter_arns" {
  description = "ARNs de todos los parámetros creados"
  value = {
    for key, param in aws_ssm_parameter.parameter_store : key => param.arn
  }
}

output "parameter_names" {
  description = "Nombres completos de todos los parámetros creados"
  value = {
    for key, param in aws_ssm_parameter.parameter_store : key => param.name
  }
}

output "parameter_versions" {
  description = "Versiones de todos los parámetros creados"
  value = {
    for key, param in aws_ssm_parameter.parameter_store : key => param.version
  }
}

output "parameter_types" {
  description = "Tipos de todos los parámetros creados"
  value = {
    for key, param in aws_ssm_parameter.parameter_store : key => param.type
  }
}

output "secure_parameters" {
  description = "Lista de parámetros de tipo SecureString"
  value = [
    for key, param in aws_ssm_parameter.parameter_store : key
    if param.type == "SecureString"
  ]
}

output "parameter_hierarchy" {
  description = "Jerarquía de parámetros organizados por cliente/proyecto/entorno"
  value = {
    client      = var.client
    project     = var.project
    environment = var.environment
    base_path   = "/${var.client}/${var.project}/${var.environment}/"
  }
}

output "kms_encrypted_parameters" {
  description = "Parámetros que utilizan cifrado KMS personalizado"
  value = {
    for key, param in aws_ssm_parameter.parameter_store : key => param.key_id
    if param.key_id != null && param.key_id != "alias/aws/ssm"
  }
}