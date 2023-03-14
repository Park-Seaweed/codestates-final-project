resource "aws_lb" "final_ecs_alb" {
  name               = "final-ecs-alb"
  subnets            = [module.network.private_subnet_id[count.index]]
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_alb_sg.id]

  tags = {
    Name = "final-ecs-alb"
  }
}

resource "aws_lb_target_group" "ecs_alb_tg" {
  name     = "ecs-alb-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    matcher             = "200"
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.final_ecs_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
  }

}


