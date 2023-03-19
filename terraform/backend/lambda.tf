data "archive_file" "ecs-scaling-alert-handler-labmda-dir-zip" {
  type        = "zip"
  output_path = "/tmp/lambda_dir_zip.zip"
  source_dir  = "./src"
}

resource "aws_lambda_function" "ecs-scaling-alert-handler" {
  filename         = data.archive_file.ecs-scaling-alert-handler-labmda-dir-zip.output_path
  source_code_hash = data.archive_file.ecs-scaling-alert-handler-labmda-dir-zip.output_base64sha256
  function_name    = "ecs-scaling-alert-handler"
  role             = aws_iam_role.ecs-scaling-alert-handler-lambda-cloudwatch-logs-role.arn
  handler          = "ecs-scaling-alert-handler.lambda_handler"

  runtime = "python3.7"

  environment {
    variables = {
      HOOK_URL = "https://hooks.slack.com/services/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"
      SLACK_CHANNEL = "#lambda"
    }
  }

  depends_on = [aws_cloudwatch_log_group.ecs-scaling-alert-handler-lambda-log]
}

resource "aws_cloudwatch_log_group" "ecs-scaling-alert-handler-lambda-log" {
  name              = "/aws/lambda/ecs-scaling-alert-handler-lambda-log-group"
  retention_in_days = 14
}

resource "aws_iam_role" "ecs-scaling-alert-handler-lambda-cloudwatch-logs-role" {
  name = "ecs-scaling-alert-handler-lambda-cloudwatch-logs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs-scaling-alert-handler-lambda-policy" {
  name        = "ecs-scaling-alert-handler-lambda-policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-scaling-alert-handler-lambda-policy-attch" {
  role       = ecs-scaling-alert-handler-lambda-cloudwatch-logs-role.name
  policy_arn = ecs-scaling-alert-handler-lambda-policy.arn
}

resource "aws_lambda_permission" "ecs-scaling-alert-handler-lambda-permission" {
  statement_id  = "AllowExecutionFromSNStopic"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs-scaling-alert-handler.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.ecs-scaling-notifications.arn
}
