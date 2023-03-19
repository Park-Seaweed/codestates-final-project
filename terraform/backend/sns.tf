resource "aws_sns_topic" "ecs-scaling-notifications" {
  name = "ecs-scaling-notifications"
}

resource "aws_sns_topic_subscription" "ecs-scaling-subscription" {
  topic_arn = aws_sns_topic.ecs-scaling-notifications.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ecs-scaling-alert-handler.arn
}

