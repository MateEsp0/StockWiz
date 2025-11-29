resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "StockWiz-HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  alarm_description  = "CPU sobre 80% durante 2 min"
  treat_missing_data = "notBreaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.stockwiz_cluster.name
  }
}
