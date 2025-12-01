# ECS SERVICE – API GATEWAY (PUBLIC SUBNETS)

resource "aws_ecs_service" "api_gateway" {
  name            = "stockwiz-api-gateway-service"
  cluster         = aws_ecs_cluster.stockwiz_cluster.id
  task_definition = aws_ecs_task_definition.api_gateway.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  # NETWORKING FIX – THE IMPORTANT PART
  network_configuration {
    subnets          = data.aws_subnets.public_subnets.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
  }

  # Load balancer mapping
  load_balancer {
    target_group_arn = aws_lb_target_group.api_gateway_tg.arn
    container_name   = "api-gateway"
    container_port   = 8000
  }

  depends_on = [
    aws_lb_listener.http_listener
  ]
}
