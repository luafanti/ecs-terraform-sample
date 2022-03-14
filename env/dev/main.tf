module "ecs_platform" {
  source = "../../modules/ecs/platform"

  name            = var.name
  cidr            = var.cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  tags = var.tags
}

module "ecs_service" {
  source = "../../modules/ecs/service"

  cluster_name       = var.name
  cluster_id         = module.ecs_platform.cluster_id
  vpc_id             = module.ecs_platform.vpc_id
  public_subnet_ids  = module.ecs_platform.public_subnets
  private_subnet_ids = module.ecs_platform.private_subnets

  expose_service = var.expose_service

  service_name          = var.service_name
  service_image         = var.service_container_image
  service_version       = var.service_container_image_version
  service_port          = var.service_container_port
  service_desired_count = var.service_desired_count

  container_cpu                = var.service_container_cpu
  container_memory             = var.service_container_memory
  container_memory_reservation = var.service_container_memory_reservation
  health_check_path            = var.service_container_hc_path
  health_check_port            = var.service_container_hc_port

  container_environment_variables = var.container_environment_variables

  route53_zone_name   = var.route53_zone_name
  route53_record_name = var.route53_record_name
  create_cloud_front  = var.create_cloud_front

  tags = var.tags
}