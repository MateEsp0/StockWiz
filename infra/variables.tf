variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "stockwiz"
}

variable "deploy_ecs" {
  type    = bool
  default = false
}
