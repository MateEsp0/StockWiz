# Arquitectura del Proyecto StockWiz

Este documento describe la arquitectura técnica implementada para el obligatorio de DevOps.  
La solución está basada en microservicios containerizados, un componente serverless y una infraestructura desplegada en AWS mediante Terraform.

---

## Visión general

La arquitectura de StockWiz se compone de tres microservicios independientes,  
una función Lambda utilizada como componente serverless y los recursos necesarios para ejecutarlos en Amazon ECS con Fargate.  
Toda la infraestructura se define como código utilizando Terraform.

---

## Microservicios

El proyecto está dividido en tres servicios principales:

### API Gateway (Go)
Servicio responsable de exponer la interfaz HTTP del sistema.  
Redirige solicitudes a los microservicios internos y sirve contenido estático.  
Construido en Go y empaquetado en una imagen ligera basada en Alpine.

### Product Service (Python)
Servicio encargado de la gestión de productos.  
Implementado en Python, empaquetado en un contenedor propio utilizando `requirements.txt` para dependencias.

### Inventory Service (Go)
Servicio encargado de manejar el inventario.  
Desarrollado en Go, con su propio Dockerfile optimizado.

Cada microservicio se construye de forma independiente siguiendo el principio de separación de responsabilidades.

---

## Containerización

- Cada servicio cuenta con un Dockerfile propio.  
- Las imágenes pueden construirse localmente y están preparadas para ser publicadas en Amazon ECR.  
- El archivo `docker-compose.yml` permite levantar todos los servicios en local para desarrollo y validación.

---

## Registro de imágenes: Amazon ECR

Se definieron tres repositorios en Amazon ECR, uno por microservicio:

- **stockwiz-api-gateway**
- **stockwiz-product-service**
- **stockwiz-inventory-service**

Estas imágenes serán utilizadas posteriormente por ECS.

---

## Orquestación: Amazon ECS con Fargate

El despliegue en la nube se realiza utilizando ECS con Fargate, lo que permite ejecutar contenedores sin administrar servidores.

### Cluster ECS
Cluster creado con el nombre **stockwiz-cluster**, donde se alojan tareas y servicios.

### Task Definitions
Cada microservicio contará con una definición de tarea que especifica:

- Imagen de contenedor  
- Puertos expuestos  
- Recursos asignados  
- Variables y configuración necesaria  

### Services
Los Services se encargarán de mantener las tareas activas dentro del cluster, asegurando disponibilidad y reemplazo automático ante fallas.

---

## Infraestructura con Terraform

La infraestructura se encuentra en la carpeta `infra/` y se compone de los siguientes archivos:

- **main.tf** — creación de VPC, subredes, cluster ECS y repositorios ECR  
- **lambda.tf** — creación de la función Lambda  
- **variables.tf** — variables reutilizadas  
- **outputs.tf** — valores generados por Terraform  
- **lambda_function.py** — código fuente de la Lambda  

El despliegue se realiza mediante:

```bash
terraform init
terraform apply
