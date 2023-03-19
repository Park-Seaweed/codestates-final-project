resource "aws_cloudwatch_metric_alarm" "ecs-service-cpu-high" {
  alarm_name          = "ecs-service-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "50"

  dimensions = {
    ClusterName = "final-test-ecs-cluster"
    ServiceName = "final-ecs-service"
  }

  alarm_description = "This metric monitors ecs cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.ecs_scale_up_policy.arn, aws_sns_topic.ecs-scaling-notifications.arn]
}

resource "aws_cloudwatch_metric_alarm" "ecs-service-cpu-low" {
  alarm_name          = "ecs-service-cpu-log"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "40"

  dimensions = {
    ClusterName = "final-test-ecs-cluster"
    ServiceName = "final-ecs-service"
  }

  alarm_description = "This metric monitors ecs cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.ecs_scale_down_policy.arn, aws_sns_topic.ecs-scaling-notifications.arn]
}
