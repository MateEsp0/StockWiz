output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.stockwiz_vpc.id
}

output "subnet_id" {
  description = "ID de la Subnet"
  value       = aws_subnet.stockwiz_subnet.id
}

output "ecs_cluster_id" {
  description = "ID del cluster ECS"
  value       = aws_ecs_cluster.stockwiz_cluster.id
}

output "ecr_repositories" {
  description = "Nombres de repositorios ECR"
  value = [
    aws_ecr_repository.api_gateway.name,
    aws_ecr_repository.inventory_service.name,
    aws_ecr_repository.product_service.name
  ]
}
