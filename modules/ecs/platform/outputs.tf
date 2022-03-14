output "vpc_id" {
  description = "The VPC ID "
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "A list of private subnets created inside the VPC"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "A list of public subnets created inside the VPC"
  value       = module.vpc.public_subnets
}

output "cluster_id" {
  description = "ECS cluster ID"
  value       = module.ecs.ecs_cluster_id
}