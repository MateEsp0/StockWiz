resource "aws_lb" "stockwiz_alb" {
  name               = "stockwiz-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.alb_sg.id]
  subnets = [
    data.aws_subnet.subnet_a.id,
    data.aws_subnet.subnet_f.id
  ]
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.stockwiz_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_gateway_tg.arn
  }
}

resource "aws_lb_target_group" "api_gateway_tg" {
  name        = "api-gateway-tg"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_lb_target_group" "inventory_service_tg" {
  name        = "inventory-service-tg"
  port        = 8002
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_lb_target_group" "product_service_tg" {
  name        = "product-service-tg"
  port        = 8001
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_lb_listener_rule" "api_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_gateway_tg.arn
  }
}

resource "aws_lb_listener_rule" "inventory_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 20

  condition {
    path_pattern {
      values = ["/inventory*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inventory_service_tg.arn
  }
}

resource "aws_lb_listener_rule" "product_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 30

  condition {
    path_pattern {
      values = ["/products*", "/product*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.product_service_tg.arn
  }
}
