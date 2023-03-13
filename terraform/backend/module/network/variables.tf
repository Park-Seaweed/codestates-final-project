variable "vpc" {
  type        = string
  description = "vpc"
}

variable "public_subnet_cidr_list" {
  type        = list(string)
  description = "pub-cidr-list"
}

variable "private_subnet_cidr_list" {
  type        = list(string)
  description = "private-cidr-list"
}

variable "rds_subnet_cidr_list" {
  type        = list(string)
  description = "rds-cidr-list"
}

variable "availability_zone_list" {
  type        = list(string)
  description = "az"
}
