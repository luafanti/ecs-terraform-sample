variable "name" {
  description = "The resource name"
  type        = string
}

variable "cloudwatch_log_retention_in_days" {
  description = "The number of days logs are to be stored"
  type        = number
  default     = 7
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}
