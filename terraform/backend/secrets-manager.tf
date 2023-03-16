resource "aws_secretsmanager_secret" "db_username" {
  name = "finalsecret/db_username"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "finalsecret/db_password"
}

resource "aws_secretsmanager_secret" "database" {
  name = "finalsecret/database"
}

resource "aws_secretsmanager_secret" "hostname" {
  name = "mysecret/hostname"
}

resource "aws_secretsmanager_secret" "read_hostname" {
  name = "mysecret/readhostname"
}


resource "aws_secretsmanager_secret_version" "db_username" {
  secret_id     = aws_secretsmanager_secret.db_username.id
  secret_string = var.database_name
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.database_passward
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id     = aws_secretsmanager_secret.database.id
  secret_string = var.database
}

resource "aws_secretsmanager_secret_version" "hostname" {
  secret_id     = aws_secretsmanager_secret.hostname.id
  secret_string = aws_rds_cluster.aurora_cluster.endpoint
}

resource "aws_secretsmanager_secret_version" "read_hostname" {
  secret_id     = aws_secretsmanager_secret.read_hostname.id
  secret_string = aws_rds_cluster.aurora_cluster.reader_endpoint
}

