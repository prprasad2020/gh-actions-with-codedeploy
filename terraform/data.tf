variable "vpc_id" {
  description = "The VPC ID"
  default     = "" # Set proper VPC ID of the AWS account
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_security_group" "ecs_sg" { # You might have to update the filters properly
  vpc_id = var.vpc_id
}

data "aws_iam_policy" "codedeploy_service_policy" {
  arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
