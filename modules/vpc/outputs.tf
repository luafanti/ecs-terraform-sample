output "vpc_id" {
  description = "The VPC ID "
  value       = module.this.vpc_id
}

output "private_subnets" {
  description = "A list of private subnets created inside the VPC"
  value       = module.this.private_subnets
}

output "public_subnets" {
  description = "A list of public subnets created inside the VPC"
  value       = module.this.public_subnets
}
