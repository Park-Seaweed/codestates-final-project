resource "aws_ecs_cluster" "final_ecs_cluster" {
  name = "final-test-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "secretsmanager_policy" {
  name = "secretsmanager_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_service_scaling" {
  name = "dev-to-scaling"
  path = "/"
  description = "Allow ecs service scaling"

  policy = data.aws_iam_policy_document.ecs_service_scaling.json
}

data "aws_iam_policy_document" "ecs_service_scaling" {

  statement {
    effect = "Allow"

    actions = [
      "application-autoscaling:*",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "iam:CreateServiceLinkedRole",
      "sns:CreateTopic",
      "sns:Subscribe",
      "sns:Get*",
      "sns:List*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_iam_role_policy_attachment" "secretsmanager_attachment" {
  policy_arn = aws_iam_policy.secretsmanager_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_service_scaling" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_service_scaling.arn
}

resource "aws_ecs_service" "final_ecs_service" {

  name            = "final-ecs-service"
  cluster         = aws_ecs_cluster.final_ecs_cluster.id
  task_definition = aws_ecs_task_definition.final_ecs_task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.network.private_subnet_id
    security_groups = [aws_security_group.ecs_task_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
    container_name   = "final-test-api"
    container_port   = 3000
  }


  depends_on = [
    aws_lb_listener.http_forward,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy
  ]
}

data "template_file" "service" {
  template = file("./demo-td-revision6.json.tpl")
  vars = {
    db_write_hostname     = data.aws_secretsmanager_secret.rds_write_hostname.arn
    db_reader_hostname    = data.aws_secretsmanager_secret.rds_read_hostname.arn
    db_password           = data.aws_secretsmanager_secret.rds_password.arn
    db_name               = data.aws_secretsmanager_secret.rds_username.arn
    database              = data.aws_secretsmanager_secret.rds_database.arn
    aws_access_key_id     = data.aws_secretsmanager_secret.aws_access_key_id.arn
    aws_secret_access_key = data.aws_secretsmanager_secret.aws_secret_access_key.arn
  }
}

resource "aws_ecs_task_definition" "final_ecs_task_definition" {
  family                   = "final-ecs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = data.template_file.service.rendered
}


resource "aws_cloudwatch_log_group" "final_ecs_log_group" {
  name = "/ecs/test/example"
}
