# Ejemplos del Módulo Parameter Store

Este directorio contiene ejemplos de uso del módulo Parameter Store para diferentes casos de uso.

## Estructura de Ejemplos

```
examples/
├── basic/          # Ejemplo básico con configuraciones simples
├── advanced/       # Ejemplo avanzado con KMS personalizado y políticas
├── custom-names/   # Ejemplo con nombres personalizados
└── README.md       # Este archivo
```

## Ejemplo Básico

El ejemplo básico (`basic/`) demuestra:
- Configuración simple de parámetros
- Uso de diferentes tipos (String, SecureString, StringList)
- Etiquetado básico con etiquetas adicionales
- Uso de KMS por defecto

### Ejecutar el ejemplo básico:

```bash
cd examples/basic
terraform init
terraform plan
terraform apply
```

## Ejemplo de Nombres Personalizados

El ejemplo de nombres personalizados (`custom-names/`) demuestra:
- Uso de la variable `custom_name` para sobrescribir nomenclatura estándar
- Compatibilidad con sistemas legacy
- Integración con servicios externos
- Organización personalizada de parámetros
- Comparación entre nombres estándar y personalizados

### Ejecutar el ejemplo de nombres personalizados:

```bash
cd examples/custom-names
terraform init
terraform plan
terraform apply
```

## Ejemplo Avanzado

El ejemplo avanzado (`advanced/`) demuestra:
- Creación de clave KMS personalizada
- Uso de tier Advanced para parámetros complejos
- Validación de patrones con `allowed_pattern`
- Etiquetado avanzado para clasificación de datos
- Configuración de parámetros JSON complejos

### Ejecutar el ejemplo avanzado:

```bash
cd examples/advanced
terraform init
terraform plan
terraform apply
```

## Casos de Uso Cubiertos

### 1. Configuración de Aplicación (Básico)
- Versiones de aplicación
- URLs de base de datos
- Listas de endpoints
- Feature flags

### 2. Seguridad y Autenticación (Avanzado)
- Tokens JWT con cifrado KMS
- Credenciales de base de datos cifradas
- Configuración OAuth
- Tokens temporales con validación

### 3. Configuración de Red (Básico/Avanzado)
- Listas de CORS
- Endpoints de API
- Configuraciones de proxy

### 3. Nombres Personalizados (Custom Names)
- Compatibilidad con sistemas legacy
- Integración con servicios externos
- Organización personalizada de jerarquías
- Migración de parámetros existentes

## Limpieza

Para limpiar los recursos creados por los ejemplos:

```bash
# Para el ejemplo básico
cd examples/basic
terraform destroy

# Para el ejemplo avanzado
cd examples/advanced
terraform destroy

# Para el ejemplo de nombres personalizados
cd examples/custom-names
terraform destroy
```

## Personalización

Puedes personalizar estos ejemplos modificando:
- Variables de cliente, funcionalidad y entorno
- Configuraciones de parámetros específicas
- Políticas de KMS y Parameter Store
- Etiquetas adicionales según tus necesidades

## Notas Importantes

1. **Costos**: El ejemplo avanzado crea una clave KMS personalizada que tiene costos asociados
2. **Seguridad**: Los valores de ejemplo contienen datos ficticios - reemplázalos con valores reales apropiados
3. **Permisos**: Asegúrate de tener los permisos IAM necesarios antes de ejecutar los ejemplos
4. **Región**: Los ejemplos están configurados para `us-east-1` - ajusta según tu región preferida
