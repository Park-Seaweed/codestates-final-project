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




resource "aws_iam_role_policy_attachment" "ssm_managed_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
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
              sudo systemctl enable amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent
              EOF

  tags = {
    Name = "final-vpn-1"
  }
}

resource "aws_cloudwatch_log_group" "session_log_group" {
  name = "/aws/ssm/final-test"
}


resource "aws_cloudwatch_log_stream" "session_log_stream" {
  name           = "session-log-stream"
  log_group_name = aws_cloudwatch_log_group.session_log_group.name
}

resource "aws_ssm_document" "session_manager_prefs" {
  name          = "SessionManagerPrefs"
  document_type = "Session"

  content = jsonencode({
    "schemaVersion" = "1.0"
    "description"   = "Session Manager preferences"
    "sessionType"   = "Standard_Stream"
    "inputs" = {
      "s3BucketName"                = ""
      "s3KeyPrefix"                 = ""
      "cloudWatchLogGroupName"      = aws_cloudwatch_log_group.session_log_group.name
      "cloudWatchEncryptionEnabled" = false
      "kmsKeyId"                    = ""
      "s3EncryptionEnabled"         = false
      "cloudWatchLogStreamName"     = aws_cloudwatch_log_stream.session_log_stream.name
      "s3EncryptionKmsKeyId"        = ""
    }
  })
}

resource "aws_ssm_association" "session_manager_prefs_association" {
  name = aws_ssm_document.session_manager_prefs.name

  targets {
    key    = "instanceids"
    values = [aws_instance.vpn_instance.id]
  }
}
