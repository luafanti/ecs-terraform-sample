variable "name" {
  description = "Name to be used on all the resources"
  type        = string
  default     = null
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = ""
  type        = map(string)
  default     = {}
}
