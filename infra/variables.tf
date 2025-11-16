variable "aws_region" {
  description = "Región despliegue de recursos"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre de recursos"
  type        = string
  default     = "stockwiz"
}

variable "deploy_ecs" {
  description = "Controla si se despliega ECS"
  type        = bool
  default     = false
}
