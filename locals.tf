
# Locals para transformaciones y cálculos internos
locals {
  # Generar nombres estándar para los parámetros
  standard_parameter_names = {
    for key, config in var.parameter_store_config : key => "/${var.client}/${var.project}/${var.environment}/${key}"
  }

  # Generar nombres finales (personalizado o estándar)
  parameter_names = {
    for key, config in var.parameter_store_config : key => (
      config.custom_name != null ? config.custom_name : local.standard_parameter_names[key]
    )
  }

  # Configuración procesada con valores por defecto
  processed_config = {
    for key, config in var.parameter_store_config : key => merge(config, {
      name       = local.parameter_names[key]
      kms_key_id = config.type == "SecureString" ? coalesce(config.kms_key_id, var.default_kms_key_id) : null
    })
  }
}
