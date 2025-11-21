resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/ecs/api-gateway"
  retention_in_days = 7
}
