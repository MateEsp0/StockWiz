resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/ecs/api-gateway"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "product_service" {
  name              = "/ecs/product-service"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "inventory_service" {
  name              = "/ecs/inventory-service"
  retention_in_days = 7
}
