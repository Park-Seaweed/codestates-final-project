terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}


module "network" {
  source = "./module/network"

  vpc = "172.16.0.0"

  public_subnet_cidr_list = [
    "172.16.1.0/24",
    "172.16.2.0/24"
  ]

  private_subnet_cidr_list = [
    "172.16.3.0/24",
    "172.16.4.0/24"
  ]

  rds_subnet_cidr_list = [
    "172.16.5.0/24",
    "172.16.6.0/24"
  ]

  availability_zone_list = [
    "ap-northeast-2a",
    "ap-northeast-2b"
  ]
}
