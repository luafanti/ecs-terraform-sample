output "lb_url_address" {
  description = "URL address of ALB"
  value       = "http://${module.ecs_service.lb_fqdns_name}"
}

output "cdn_url_address" {
  description = "URL address of CDN"
  value       = var.create_cloud_front ? "https://${module.ecs_service.cdn_fqdns_name}" : "CDN not configured"
}
