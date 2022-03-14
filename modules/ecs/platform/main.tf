locals {
  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}

#Disable Wavelength Zone
data "aws_availability_zones" "available" {
  all_availability_zones = false
}

module "vpc" {
  source = "../../../modules/vpc"

  name            = var.name
  cidr            = var.cidr
  azs             = data.aws_availability_zones.available.names
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  tags = var.tags
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.4.1"

  name               = var.name
  container_insights = var.container_insights
  capacity_providers = ["FARGATE"]

  tags = local.tags
}
