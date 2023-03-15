# data "aws_iam_policy_document" "ec2_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }
# data "aws_iam_policy" "systems_manager" {
#   arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }


# resource "aws_iam_role" "ec2_role" {
#   name               = "ec2-ssm-role"
#   assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "ec2_ssm" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = data.aws_iam_policy.systems_manager.arn
# }

resource "aws_iam_role" "session_manager_role" {
  name = "session-manager-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "session_manager_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.session_manager_role.name
}


resource "aws_instance" "vpn_instance" {
  ami                         = var.vpn_ami
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = module.network.public_subnet_id[0]
  key_name                    = "myKey"
  associate_public_ip_address = "true"
  iam_instance_profile        = aws_iam_role.session_manager_role.name
  user_data                   = <<-EOF
               #!/bin/bash
               echo "Hello, World" > index.html
               nohup busybox httpd -f -p 8080 &
               EOF

  tags = {
    Name = "final-vpn-1"
  }
}
