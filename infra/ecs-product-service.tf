resource "aws_ecs_service" "product_service" {
  name            = "stockwiz-product-service"
  cluster         = aws_ecs_cluster.stockwiz_cluster.id
  task_definition = aws_ecs_task_definition.product_service.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [data.aws_subnet.subnet_a.id, data.aws_subnet.subnet_f.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs.id]
  }
}
