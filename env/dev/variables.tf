### AWS account configuration
variable "aws_allowed_account_ids" {
  description = "List of allowed AWS account ids where resources can be created"
  type        = list(string)
  default     = []
}

variable "aws_region" {
  description = "Region in which stack will be created"
  type        = string
}

### General Configuration
variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type        = string
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

### VPC
variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
}

### Custom service
variable "expose_service" {
  description = "Expose the service with ALB"
  type        = bool
  default     = false
}

variable "service_name" {
  description = "Name of service that will be installed in ECS"
  type        = string
}

variable "service_container_image" {
  description = "Docker image of service that will be installed in ECS"
  type        = string
}

variable "service_container_image_version" {
  description = "Docker image version of service that will be installed in ECS"
  type        = string
}

variable "service_container_port" {
  description = "Port exposed by service"
  type        = number
}

variable "service_container_cpu" {
  description = "The number of CPU units (vCPU/1024) used by the container"
  type        = number
  default     = 512
}

variable "service_container_memory" {
  description = "The amount of RAM (in MiB) used by the task"
  type        = number
  default     = 1024
}

variable "service_desired_count" {
  description = "The desired number of instances"
  type        = number
  default     = 1
}

variable "service_container_memory_reservation" {
  description = "The amount of RAM (in MiB) to reserve for the container"
  type        = string
  default     = 512
}

variable "service_container_hc_path" {
  description = "Health check container path"
  type        = string
  default     = "/"
}

variable "service_container_hc_port" {
  description = "Health check container port"
  type        = number
  default     = 80
}

variable "container_environment_variables" {
  description = "List of environment variables the container will use"
  type = list(object(
    {
      name  = string
      value = string
    }
  ))
  default = []
}

### DNS
variable "route53_zone_name" {
  description = "Route53 zone name"
  type        = string
}

variable "route53_record_name" {
  description = "Route53 record name"
  type        = string
}

variable "create_route53_record" {
  description = "Create Route53 record for the resource"
  type        = bool
  default     = true
}

### CDN
variable "create_cloud_front" {
  description = "Create Cloud Front distribution (CDN)"
  type        = bool
  default     = false
}