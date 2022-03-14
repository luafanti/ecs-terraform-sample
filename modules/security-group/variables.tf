variable "name" {
  description = "The resource name"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The VPC ID to use"
  type        = string
  default     = ""
}

variable "ingress_cidr_blocks" {
  description = "A list of CIDR annotated IPs to apply"
  type        = list(string)
}

variable "tags" {
  description = "A list of tags to apply to all the resources"
  type        = map(string)
  default     = {}
}
