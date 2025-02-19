provider "aws" {
  region  = "eu-central-1"
  profile = "medium-test"
}

terraform {
  required_version = "1.10.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " >= 5.84.0"
    }
  }
}
