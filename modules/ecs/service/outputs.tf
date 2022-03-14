output "lb_fqdns_name" {
  description = "The FQDNs of the Route53 for the load balancer"
  value       = module.lb_dns[0].fqdns
}

output "cdn_fqdns_name" {
  description = "The FQDNs of the Route53 for the Cloud Front"
  value       = module.cdn_dns[0].fqdns
}



