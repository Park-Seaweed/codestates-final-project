resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "awurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.1"
  database_name           = "final-database"
  master_username         = var.database_name
  master_password         = var.database_passward
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  availability_zones      = [module.network.availability_zone_list[0], module.network.availability_zone_list[1]]

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}


resource "aws_rds_cluster_instance" "aurora_instance" {
  count               = 2
  identifier          = "final-aurora-cluster-${count.index}"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = "db.t3.small"
  engine              = aws_rds_cluster.aurora_cluster.engine
  engine_version      = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = false
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = module.network.rds_subnet_id
}

