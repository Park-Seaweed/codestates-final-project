resource "aws_iam_role" "ssm_role" {
  name = "SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ssm_cloudwatch_policy" {
  name        = "SSMCloudWatchPolicy"
  description = "Policy for logging SSM Session Manager to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_cloudwatch_policy_attachment" {
  policy_arn = aws_iam_policy.ssm_cloudwatch_policy.arn
  role       = aws_iam_role.ssm_role.name
}



resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_eip" "vpn_eip" {
  instance = aws_instance.vpn_instance.id
}

resource "aws_eip_association" "vpn_eip_assoc" {
  instance_id   = aws_instance.vpn_instance.id
  allocation_id = aws_eip.vpn_eip.id
}

resource "aws_cloudwatch_log_group" "ssm_log_group" {
  name = "/aws/ssm/vpn-instance"
}

resource "aws_cloudwatch_log_stream" "ssm_log_stream" {
  name           = "session-logs"
  log_group_name = aws_cloudwatch_log_group.ssm_log_group.name
}


resource "aws_instance" "vpn_instance" {
  ami                         = var.vpn_ami
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = module.network.public_subnet_id[0]
  key_name                    = "myKey"
  associate_public_ip_address = "true"
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name
  user_data                   = <<-EOF
               #!/bin/bash
              sudo yum install -y amazon-ssm-agent

              
              REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
              INSTANCE_ID=$(curl --silent http://169.254.169.254/latest/meta-data/instance-id)
              LOG_GROUP_NAME="${aws_cloudwatch_log_group.ssm_log_group.name}"
              LOG_STREAM_NAME="${aws_cloudwatch_log_stream.ssm_log_stream.name}"
              sudo tee /etc/amazon/ssm/amazon-ssm-agent.json <<-AGENT_JSON
              {
                "Mds": {
                  "LogGroupName": "$LOG_GROUP_NAME",
                  "LogStreamName": "$LOG_STREAM_NAME",
                  "Region": "$REGION"
                },
                "Os": {
                  "Lang": "en-US"
                },
                "Ssm": {
                  "S3": {
                    "Region": "$REGION"
                  }
                }
              }
              AGENT_JSON

              sudo systemctl enable amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent
              EOF

  tags = {
    Name = "final-vpn-1"
  }
}

