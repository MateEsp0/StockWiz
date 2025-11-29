resource "aws_cloudwatch_dashboard" "stockwiz_dashboard" {
  dashboard_name = "StockWiz-Monitoring"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "CpuUtilized", "ClusterName", "stockwiz-cluster"]
          ]
          period      = 60
          stat        = "Average"
          title       = "CPU Utilization - ECS Cluster"
          region      = var.aws_region
          annotations = {}
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "MemoryUtilized", "ClusterName", "stockwiz-cluster"]
          ]
          period      = 60
          stat        = "Average"
          title       = "Memory Utilization - ECS Cluster"
          region      = var.aws_region
          annotations = {}
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "RunningTaskCount", "ClusterName", "stockwiz-cluster"]
          ]
          period      = 60
          stat        = "Sum"
          title       = "Running Tasks - ECS Cluster"
          region      = var.aws_region
          annotations = {}
        }
      }
    ]
  })
}
