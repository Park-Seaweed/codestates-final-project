variable "database_name" {
  description = "database-name"
  type        = string

}

variable "database_passward" {
  description = "database-passward"
  type        = string

}

variable "database" {
  description = "database"
  type        = string

}

variable "vpn_ami" {
  description = "vpn-ami"
  type        = string

}
variable "rds_cluster_write_endpoint" {
  default = aws_rds_cluster.aurora_cluster.endpoint
}

variable "rds_cluster_read_endpoint" {
  default = aws_rds_cluster.aurora_cluster.reader_endpoint
}
