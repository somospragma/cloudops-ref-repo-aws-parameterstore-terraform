# Recurso principal: AWS SSM Parameter
resource "aws_ssm_parameter" "parameter_store" {
  provider = aws.project
  for_each = local.processed_config

  name            = each.value.name
  type            = each.value.type
  value           = each.value.value
  description     = each.value.description
  tier            = each.value.tier
  overwrite       = each.value.overwrite
  allowed_pattern = each.value.allowed_pattern
  data_type       = each.value.data_type
  key_id          = each.value.kms_key_id

  # Sistema de etiquetado estándar
  tags = merge(
    {
      Name          = "${var.client}-${var.project}-${var.environment}-ssm-${each.key}"
      #ParameterPath = each.value.name
    },
    each.value.additional_tags
  )

  # lifecycle {
  #   ignore_changes = [
  #     # Ignorar cambios en el valor si se gestiona externamente
  #     value
  #   ]
  # }
}
