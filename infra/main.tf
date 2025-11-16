terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "api_gateway" {
  name = "stockwiz-api-gateway"
 force_delete  = true

}

resource "aws_ecr_repository" "inventory_service" {
  name = "stockwiz-inventory-service"
    force_delete  = true

}

resource "aws_ecr_repository" "product_service" {
  name = "stockwiz-product-service"
    force_delete  = true

}

resource "aws_vpc" "stockwiz_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "stockwiz_subnet" {
  vpc_id                  = aws_vpc.stockwiz_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_ecs_cluster" "stockwiz_cluster" {
  name = "stockwiz-cluster"
}

resource "aws_ecs_task_definition" "api_gateway_task" {
  count                    = var.deploy_ecs ? 1 : 0
  family                   = "api-gateway-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "api-gateway"
      image     = "905418384536.dkr.ecr.us-east-1.amazonaws.com/stockwiz-api-gateway:latest"
      essential = true
      portMappings = [{
        containerPort = 8000
        hostPort      = 8000
      }]
    }
  ])
}

resource "aws_ecs_service" "api_gateway_service" {
  count           = var.deploy_ecs ? 1 : 0
  name            = "api-gateway-service"
  cluster         = aws_ecs_cluster.stockwiz_cluster.id
  task_definition = aws_ecs_task_definition.api_gateway_task[0].arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.stockwiz_subnet.id]
    assign_public_ip = true
  }
}
