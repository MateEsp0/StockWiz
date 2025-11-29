resource "aws_ecs_service" "inventory_service" {
  name            = "stockwiz-inventory-service"
  cluster         = aws_ecs_cluster.stockwiz_cluster.id
  task_definition = aws_ecs_task_definition.inventory_service.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = data.aws_subnets.public_subnets.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.inventory_service_tg.arn
    container_name   = "inventory-service"
    container_port   = 8002
  }

  depends_on = [
    aws_lb_listener.http_listener
  ]
}
