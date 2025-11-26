resource "aws_ecs_task_definition" "api_gateway" {
  family                   = "stockwiz-api-gateway-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = data.aws_iam_role.lab_role.arn
  task_role_arn      = data.aws_iam_role.lab_role.arn


  container_definitions = jsonencode([
    {
      name      = "api-gateway"
      image     = "${aws_ecr_repository.api_gateway.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "wget -q -O /dev/null http://localhost:8000/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 10
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/api-gateway"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      depends_on = [
        aws_cloudwatch_log_group.api_gateway
      ]

    }
  ])
}
