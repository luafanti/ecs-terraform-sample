output "name" {
  description = "The CloudWatch log group name"
  value       = aws_cloudwatch_log_group.this.name
}

output "region" {
  description = "The region of the CloudWatch log group"
  value       = data.aws_region.current.name
}
