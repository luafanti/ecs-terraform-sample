module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.4.0"

  name = var.name

  vpc_id          = var.vpc_id
  subnets         = var.public_subnet_ids
  security_groups = var.security_groups

  access_logs = {
    enabled = var.logging_enabled
    bucket  = var.log_bucket_name
    prefix  = var.log_location_prefix
  }

  listener_ssl_policy_default = var.listener_ssl_policy_default

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "forward"
    },
  ]

  target_groups = [
    {
      name_prefix      = var.name_prefix
      name             = var.name
      backend_port     = var.service_port
      backend_protocol = var.service_protocol

      target_type          = "ip"
      deregistration_delay = 10

      health_check = {
        enabled  = true
        port     = var.health_check_port == null ? var.service_port : var.health_check_port
        protocol = var.service_protocol
        path     = var.health_check_path
      }
    },
  ]

  tags = var.tags
}
