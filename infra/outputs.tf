##############################################
# OUTPUTS PRINCIPALES DEL PROYECTO STOCKWIZ
##############################################

# VPC utilizada
output "vpc_id" {
  description = "ID de la VPC utilizada por StockWiz"
  value       = data.aws_vpc.main.id
}

# Subnets públicas donde se despliegan los servicios
output "public_subnet_ids" {
  description = "Lista de subnets públicas detectadas automáticamente"
  value       = data.aws_subnets.public_subnets.ids
}

# ECS Cluster
output "ecs_cluster_name" {
  description = "Nombre del cluster ECS donde se ejecutan los microservicios"
  value       = aws_ecs_cluster.stockwiz_cluster.name
}

# ECR Repositories (para CI/CD)
output "ecr_api_gateway" {
  description = "Repositorio ECR para API Gateway"
  value       = aws_ecr_repository.api_gateway.repository_url
}

output "ecr_product_service" {
  description = "Repositorio ECR para Product Service"
  value       = aws_ecr_repository.product_service.repository_url
}

output "ecr_inventory_service" {
  description = "Repositorio ECR para Inventory Service"
  value       = aws_ecr_repository.inventory_service.repository_url
}

# ALB Público
output "alb_dns_name" {
  description = "DNS público del Application Load Balancer"
  value       = aws_lb.stockwiz_alb.dns_name
}

##############################################
# FIN DE OUTPUTS
##############################################
