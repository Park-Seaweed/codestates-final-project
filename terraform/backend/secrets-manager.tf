data "aws_secretsmanager_secret" "rds_read_hostname" {
  name = "final-terraform/readhostname"
}

data "aws_secretsmanager_secret" "rds_write_hostname" {
  name = "final-terraform/writehostname"
}

data "aws_secretsmanager_secret" "rds_username" {
  name = "final-terraform/username"
}

data "aws_secretsmanager_secret" "rds_password" {
  name = "final-terraform/password"
}

data "aws_secretsmanager_secret" "rds_database" {
  name = "final-terraform/database"
}


data "aws_secretsmanager_secret" "aws_access_key_id" {
  name = "final-terraform/aws-access-key-id"
}

data "aws_secretsmanager_secret" "aws_secret_access_key" {
  name = "final-terraform/aws-secret-access-key"
}
