output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm[0].acm_certificate_arn
}
