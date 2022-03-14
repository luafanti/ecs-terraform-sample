variable "name" {
  description = "The resource name"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "The resource name prefix"
  type        = string
  default     = null
}

variable "internal" {
  description = "Configure ALB as internal"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "ID of an existing VPC where resources will be created"
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "A list of IDs of existing public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "security_groups" {
  description = "List of security groups to be used"
  type        = list(string)
  default     = []
}

variable "logging_enabled" {
  description = "Enable logging"
  type        = bool
  default     = false
}

variable "log_bucket_name" {
  description = "S3 bucket for the logs"
  type        = string
  default     = ""
}

variable "log_location_prefix" {
  description = "A prefix for the log location"
  type        = string
  default     = ""
}

variable "listener_ssl_policy_default" {
  description = "The default ssl policy to apply"
  type        = string
  default     = ""
}

variable "authentication_method" {
  description = "The authentication method to apply. (basic|forward|authenticate-cognito)"
  type        = string
  default     = "forward"
}

variable "authenticate_basic_users" {
  description = "User list for basic authentication"
  type        = list(object({ username = string, password = string }))
  default     = []
}

variable "authenticate_cognito_user_pool_arn" {
  description = "The cognito user pool arn"
  type        = string
  default     = ""
}

variable "authenticate_cognito_user_pool_client_id" {
  description = "The cognito user pool client ID"
  type        = string
  default     = ""
}

variable "authenticate_cognito_user_pool_domain" {
  description = "The cognito user pool domain."
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "The certificate's arn to use."
  type        = string
  default     = ""
}

variable "service_port" {
  description = "The port of the service."
  type        = number
  default     = 80
}

variable "service_protocol" {
  description = "The protocol of the service"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "The URI to the health check resource"
  type        = string
  default     = "/health"
}

variable "health_check_port" {
  description = "The Port to the health check resource"
  type        = number
  default     = null
}

variable "tags" {
  description = "A list of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
