# Pipeline CI/CD del Proyecto StockWiz

Este documento describe el pipeline de integración continua (CI) y entrega continua (CD) implementado para el proyecto StockWiz utilizando GitHub Actions.

## Objetivos del pipeline

El pipeline garantiza que:
- El código se valide automáticamente.
- Las imágenes Docker puedan construirse de forma consistente.
- Cada push a las ramas principales active un flujo adecuado según el ambiente.
- Se mantenga la calidad del código base para futuras entregas.

## Estructura del pipeline

El repositorio contiene tres flujos principales:

### 1. CI DEV – Desarrollo
Ubicación: `.github/workflows/dev.yml`

Acciona cuando:
- Se hace push a la rama `develop`.

Tareas:
- Construcción de los microservicios con Docker.
- Validación básica del proyecto.
- Proceso rápido para retroalimentación del desarrollador.

### 2. CI TEST – Pruebas
Ubicación: `.github/workflows/test.yml`

Acciona cuando:
- Se hace push o pull request hacia `release/test`.

Tareas:
- Construcción de imágenes en modo test.
- Ejecución de validaciones o pruebas adicionales.
- Preparación para la integración con ECS.

### 3. CD PROD – Producción
Ubicación: `.github/workflows/prod.yml`

Acciona cuando:
- Se hace push a la rama `main`.

Tareas:
- Construcción de imágenes para producción.
- Preparación del paquete para despliegue.
- Responsable de la entrega final hacia los servicios cloud.

## Integración con Docker

Todos los workflows construyen imágenes Docker para:

- `api-gateway`
- `product-service`
- `inventory-service`

Esto asegura consistencia entre ambientes.

## Estado actual

A la fecha:
- Workflows creados y funcionales.
- CI DEV probado correctamente.
- CD PROD ejecuta un test de pipeline exitoso.
- Pendiente integrar publicación automática hacia ECR y ECS.