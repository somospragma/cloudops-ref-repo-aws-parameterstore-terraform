# Ejemplo: Nombres Personalizados

Este ejemplo demuestra cómo usar la funcionalidad de nombres personalizados (`custom_name`) en el módulo Parameter Store.

## Funcionalidad

La variable `custom_name` permite sobrescribir la nomenclatura estándar del módulo cuando sea necesario, manteniendo la flexibilidad para casos especiales como:

- Compatibilidad con sistemas legacy
- Integración con servicios externos que requieren nombres específicos
- Organización personalizada de parámetros
- Migración de parámetros existentes

## Comportamiento

- **Sin `custom_name`**: Se usa la nomenclatura estándar `/{client}/{functionality}/{environment}/{parameter_key}`
- **Con `custom_name`**: Se usa exactamente el nombre proporcionado

## Ejemplo de Uso

```bash
# Inicializar Terraform
terraform init

# Planificar los cambios
terraform plan

# Aplicar la configuración
terraform apply
```

## Resultados Esperados

Los parámetros se crearán con los siguientes nombres:

| Clave del Parámetro | Nombre Final | Tipo |
|---------------------|--------------|------|
| `standard-config` | `/pragma/analytics/dev/standard-config` | Estándar |
| `custom-analytics-db` | `/analytics/database/connection-string` | Personalizado |
| `legacy-api-key` | `/legacy/systems/api-key` | Personalizado |
| `external-service-config` | `/external/analytics-service/config` | Personalizado |
| `data-sources` | `/analytics/data-sources/list` | Personalizado |

## Casos de Uso Comunes

1. **Sistemas Legacy**: Mantener nombres existentes durante migraciones
2. **Servicios Externos**: Cumplir con convenciones de naming de terceros
3. **Organización Específica**: Crear jerarquías personalizadas por proyecto
4. **Compatibilidad**: Integrar con infraestructura existente

## Notas Importantes

- El `custom_name` debe incluir la ruta completa (comenzar con `/`)
- Las etiquetas estándar se mantienen independientemente del nombre personalizado
- La validación y cifrado funcionan igual que con nombres estándar
