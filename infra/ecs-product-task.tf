resource "aws_ecs_task_definition" "product_service" {
  family                   = "stockwiz-product-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = data.aws_iam_role.lab_role.arn
  task_role_arn      = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name      = "product-service"
      image     = "${aws_ecr_repository.product_service.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 8001
          hostPort      = 8001
          protocol      = "tcp"
        }
      ]

      healthCheck = {
          command     = ["CMD-SHELL", "curl -f http://localhost:8001/health || exit 1"]
          interval    = 30
          timeout     = 5
          retries     = 3
          startPeriod = 15
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/product-service"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }

      depends_on = [
        aws_cloudwatch_log_group.product_service
      ]
    }
  ])
}
