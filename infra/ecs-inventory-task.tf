resource "aws_ecs_task_definition" "inventory_service" {
  family                   = "stockwiz-inventory-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = data.aws_iam_role.lab_role.arn
  task_role_arn      = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name      = "inventory-service"
      image     = "${aws_ecr_repository.inventory_service.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 8002
          hostPort      = 8002
          protocol      = "tcp"
        }
      ]

      healthCheck = {
        command     = ["CMD-SHELL", "wget -q -O /dev/null http://localhost:8002/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 10
      }

      environment = [
        # no variables por ahora
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/inventory-service"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }

      depends_on = [
        aws_cloudwatch_log_group.inventory_service
      ]
    }
  ])
}
