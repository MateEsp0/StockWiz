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
  name         = "stockwiz-api-gateway"
  force_delete = true
}

resource "aws_ecr_repository" "inventory_service" {
  name         = "stockwiz-inventory-service"
  force_delete = true
}

resource "aws_ecr_repository" "product_service" {
  name         = "stockwiz-product-service"
  force_delete = true
}

resource "aws_ecs_cluster" "stockwiz_cluster" {
  name = "stockwiz-cluster"
}
