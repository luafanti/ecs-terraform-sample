module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "v3.17.0"

  name        = "${var.name}-alb-http"
  vpc_id      = var.vpc_id
  description = "Security group with HTTP ports open for specific IPv4 CIDR block (or everybody), egress ports are world open"

  ingress_cidr_blocks = var.ingress_cidr_blocks

  tags = var.tags
}
