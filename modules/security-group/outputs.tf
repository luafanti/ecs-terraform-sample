output "http_security_group_id" {
  description = "The HTTP security group ID"
  value       = module.alb_http_sg.this_security_group_id
}