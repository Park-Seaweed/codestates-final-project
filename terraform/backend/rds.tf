resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.1"
  database_name           = var.database
  master_username         = var.database_name
  master_password         = var.database_passward
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  availability_zones = [
    "ap-northeast-2a",
    "ap-northeast-2b"
  ]
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.id

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}


resource "aws_rds_cluster_instance" "aurora_instance" {
  count               = 2
  identifier          = "final-aurora-cluster-${count.index}"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = "db.t3.small"
  publicly_accessible = false

  monitoring_interval = "60"
  monitoring_role_arn = aws_iam_role.enhanced_monitoring.arn

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  performance_insights_kms_key_id       = aws_kms_key.performance_insights_key.arn

}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = module.network.rds_subnet_id
}

resource "aws_iam_role" "enhanced_monitoring" {
  name = "rds-enhanced-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = aws_iam_role.enhanced_monitoring.name
}

resource "aws_kms_key" "performance_insights_key" {
  description = "Performance insights key for RDS"
}
