terraform {
  required_proiders {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63.0"
    }
  }
}



provider "aws" {
  region = "ap-northeast-2"
}
