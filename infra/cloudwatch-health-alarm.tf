resource "aws_cloudwatch_metric_alarm" "product_unhealthy" {
  alarm_name          = "StockWiz-ProductService-Unhealthy"
  namespace           = "AWS/ECS"
  metric_name         = "UnhealthyTaskCount"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1
  period              = 60
  statistic           = "Maximum"

  alarm_description = "Dispara cuando product-servuce reporta unhealthy tasks"

  dimensions = {
    ClusterName = aws_ecs_cluster.stockwiz_cluster.name
    ServiceName = aws_ecs_service.product_service.name
  }
}
