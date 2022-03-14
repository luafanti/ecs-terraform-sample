terraform {
  required_version = "~> 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.4.0"
    }
  }

  backend "local" {
    path = "state/terraform.tfstate"
  }
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = var.aws_allowed_account_ids
}
