output "target_group_arns" {
  description = "ARNs of listeners"
  value       = module.alb.target_group_arns
}

output "lb_dns_name" {
  description = "The domain name corresponding to the the load balancer"
  value       = module.alb.lb_dns_name
}

output "lb_zone_id" {
  description = "Load balancer Route 53 zone ID"
  value       = module.alb.lb_zone_id
}
