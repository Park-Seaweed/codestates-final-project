variable "aws_region" {
  description = "The AWS region"
  default     = "ap-northeast-2"
}

variable "source_repo_name" {
  description = "Source repo name"
  type        = string
}

variable "source_repo_branch" {
  description = "Source repo branch"
  type        = string
}

variable "github_Owner" {
  description = "github_Owner"
  type        = string
}

variable "react_env" {
  description = "react_env"
  type        = string
}

variable "backend_endpoint" {
  description = "backend_endpoint"
  type        = string
}