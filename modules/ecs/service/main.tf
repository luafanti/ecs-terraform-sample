locals {
  cdn_dns_prefix      = "cdn-"
  fqdn_cdn_alias      = "${local.cdn_dns_prefix}${var.route53_record_name}.${var.route53_zone_name}"
  ingress_cidr_blocks = "0.0.0.0/0"
}

module "cw" {
  source = "../../../modules/cloudwatch"

  name                             = var.service_name
  cloudwatch_log_retention_in_days = 7
  tags                             = var.tags
}

module "lb" {
  source = "../../alb"
  count  = var.expose_service == true ? 1 : 0

  name = "${var.cluster_name}-${var.service_name}-lb"

  vpc_id            = var.vpc_id
  public_subnet_ids = var.public_subnet_ids
  security_groups = flatten([
    module.lb_sg[0].http_security_group_id,
  ])

  service_port      = var.service_port
  service_protocol  = "HTTP"
  health_check_path = var.health_check_path
  health_check_port = var.health_check_port

  tags = var.tags
}

module "service_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name = "${var.cluster_name}-${var.service_name}"

  vpc_id      = var.vpc_id
  description = "Security group with open ports - ingress: (${var.service_port}), egress: ALL"

  ingress_with_cidr_blocks = var.health_check_port != null && var.service_port != var.health_check_port ? [
    {
      from_port   = var.service_port
      to_port     = var.service_port
      protocol    = "tcp"
      description = "Service port"
      cidr_blocks = local.ingress_cidr_blocks
    },
    {
      from_port   = var.health_check_port
      to_port     = var.health_check_port
      protocol    = "tcp"
      description = "Management port"
      cidr_blocks = local.ingress_cidr_blocks
    },
    ] : [
    {
      from_port   = var.service_port
      to_port     = var.service_port
      protocol    = "tcp"
      description = "Service port"
      cidr_blocks = local.ingress_cidr_blocks
    },
  ]

  egress_rules = ["all-all"]

  tags = var.tags
}

module "lb_sg" {
  source = "../../security-group"
  count  = var.expose_service == true ? 1 : 0

  name = "${var.cluster_name}-${var.service_name}"

  vpc_id              = var.vpc_id
  ingress_cidr_blocks = [local.ingress_cidr_blocks]

  tags = var.tags
}

module "cdn" {
  source = "../../../modules/cdn"
  count  = var.create_cloud_front == true ? 1 : 0

  aliases            = [local.fqdn_cdn_alias]
  origin_domain_name = module.lb[0].lb_dns_name
  certificate_arn    = module.acm.acm_certificate_arn
}

module "lb_dns" {
  source = "../../dns"
  count  = var.expose_service == true ? 1 : 0

  route53_zone_name   = var.route53_zone_name
  route53_record_name = var.route53_record_name
  alias_name          = module.lb[0].lb_dns_name
  alias_zone_id       = module.lb[0].lb_zone_id

}

module "cdn_dns" {
  source = "../../dns"
  count  = var.create_cloud_front == true ? 1 : 0

  route53_zone_name   = var.route53_zone_name
  route53_record_name = "${local.cdn_dns_prefix}${var.route53_record_name}"
  alias_name          = module.cdn[0].cf_dns_name
  alias_zone_id       = module.cdn[0].cf_zone_id
}

module "acm" {
  source = "../../../modules/acm"

  providers = {
    aws = aws.use1
  }

  request_certificate = var.create_cloud_front
  route53_zone_name   = var.route53_zone_name

  tags = var.tags
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}
