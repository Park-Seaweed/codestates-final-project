resource "aws_ecs_cluster" "final_ecs_cluster" {
  name = "final-test-ecs-cluster"
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


resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_ecs_service" "final_ecs_service" {

  name            = "final-ecs-service"
  cluster         = aws_ecs_cluster.final_ecs_cluster.id
  task_definition = aws_ecs_task_definition.final_ecs_task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.network.private_subnet_id
    security_groups = [aws_security_group.ecs_alb_sg.id]
  }
  depends_on = [
    aws_lb_listener.http_forward,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy
  ]
}

resource "aws_ecs_task_definition" "final_ecs_task_definition" {
  family                   = "final-ecs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<TASK_DEFINITION
[
    {
        "name": "final-test-api",
        "image": "901512289056.dkr.ecr.ap-northeast-2.amazonaws.com/demo-project4:v5",
        "cpu": 0,
        "portMappings": [
            {
                "name": "final-test-api-3000-tcp",
                "containerPort": 3000,
                "hostPort": 3000,
                "protocol": "tcp",
                "appProtocol": "http"
            }
        ],
        "essential": true,
        "environment": [],
        "environmentFiles": [],
        "mountPoints": [],
        "volumesFrom": [],
        "secrets": [
            {
                "name": "HOSTNAME",
                "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:901512289056:secret:demo-P2n0cc:HOSTNAME::"
            },
            {
                "name": "PASSWORD",
                "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:901512289056:secret:demo-P2n0cc:PASSWORD::"
            },
            {
                "name": "DATABASE",
                "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:901512289056:secret:demo-P2n0cc:DATABASE::"
            },
            {
                "name": "READ_HOSTNAME",
                "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:901512289056:secret:demo-P2n0cc:READ_HOSTNAME::"
            },
            {
                "name": "USERNAME",
                "valueFrom": "arn:aws:secretsmanager:ap-northeast-2:901512289056:secret:demo-P2n0cc:USERNAME::"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-create-group": "true",
                "awslogs-group": "/ecs/test/example",
                "awslogs-region": "ap-northeast-2",
                "awslogs-stream-prefix": "ecs"
            }
        }
    }
]
TASK_DEFINITION



}




resource "aws_cloudwatch_log_group" "final_ecs_log_group" {
  name = "/ecs/test/example"
}
