resource "aws_security_group" "ec2_sg" {
  vpc_id = module.network.vpc_id
  name   = "ec2-sg"

  ingress = [{
    cidr_blocks      = []
    description      = "none"
    from_port        = 943
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 943
    },
    {
      cidr_blocks      = []
      description      = "none"
      from_port        = 945
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 945
    },
    {
      cidr_blocks      = []
      description      = "none"
      from_port        = 1194
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "udp"
      security_groups  = []
      self             = false
      to_port          = 1194
    },
    {
      cidr_blocks      = []
      description      = "none"
      from_port        = 8080
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 8080
  }]
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "none"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
}

resource "aws_security_group" "ecs_task_sg" {
  vpc_id = module.network.vpc_id
  name   = "ecs-task-sg"

  ingress = [{

    description      = "3000"
    from_port        = 3000
    protocol         = "tcp"
    security_groups  = [aws_security_group.ecs_alb_sg.id]
    to_port          = 3000
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
    cidr_blocks      = []




  }]
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
    security_groups  = []
    description      = "NONE"

  }]
}

resource "aws_security_group" "ecs_alb_sg" {
  vpc_id = module.network.vpc_id
  name   = "ecs-alb-sg"

  ingress = [{
    description      = "80"
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 80
    protocol         = "tcp"
    to_port          = 80
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
    security_groups  = []

    },
    {
      description      = "443"
      cidr_blocks      = ["0.0.0.0/0"]
      from_port        = 443
      protocol         = "tcp"
      to_port          = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
      security_groups  = []

  }]
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
    security_groups  = []
    description      = "NONE"

  }]
}

resource "aws_security_group" "rds_sg" {
  name        = "final-rds-sg"
  description = "Allow inbound traffic to Aurora RDS"
  vpc_id      = module.network.vpc_id

  ingress = [{
    cidr_blocks      = []
    description      = "rds-task-sg"
    from_port        = 3306
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = [aws_security_group.ecs_task_sg.id]
    self             = false
    to_port          = 3306
    },
    {
      cidr_blocks      = ["172.16.0.0/16"]
      description      = "vpc"
      from_port        = 3306
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
  }]
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "rds-outbound"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
}

