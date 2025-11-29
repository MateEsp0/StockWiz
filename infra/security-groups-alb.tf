############################################
# SECURITY GROUP PARA EL LOAD BALANCER (ALB)
############################################

resource "aws_security_group" "alb_sg" {
  name        = "stockwiz-alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "stockwiz-alb-sg"
  }
}

###############################################
# SECURITY GROUP PARA LAS ECS TASKS (API, PRODUCT, INVENTORY)
###############################################

resource "aws_security_group" "ecs_tasks_sg" {
  name        = "stockwiz-ecs-tasks-sg"
  description = "Allow ALB to reach ECS tasks"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description     = "Allow ALB to ECS tasks"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "Allow ALB to PRODUCT service"
    from_port       = 8001
    to_port         = 8001
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "Allow ALB to INVENTORY service"
    from_port       = 8002
    to_port         = 8002
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "stockwiz-ecs-tasks-sg"
  }
}
