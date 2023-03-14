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

resource "aws_ecs_task_definition" "final_ecs_task_definition" {
  family                   = "final-ecs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = file("./demo-td-revision6.json")
}

resource "aws_lb_target_group_attachment" "alb_tga" {
  target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
  target_id        = aws_ecs_service.final_ecs_service.id
  port             = 3000
}





resource "aws_cloudwatch_log_group" "final_ecs_log_group" {
  name = "/ecs/test/example"
}
