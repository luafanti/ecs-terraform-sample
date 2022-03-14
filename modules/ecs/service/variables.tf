### General Variables
variable "cluster_name" {
  description = "The cluster name"
  type        = string
}

variable "cluster_id" {
  description = "The cluster ID from aws_ecs_cluster"
  type        = string
}

variable "expose_service" {
  description = "Expose the service with ALB"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

### ECS Task & Container definition
variable "service_name" {
  description = "The service name"
  type        = string
  default     = ""
}

variable "service_image" {
  description = "Container image of the service"
  type        = string
}

variable "service_version" {
  description = "Version label of the service to run. If not specified latest will be used"
  type        = string
  default     = "latest"
}

variable "service_port" {
  description = "Local port service should be running on"
  type        = number
  default     = 80
}

variable "service_desired_count" {
  description = "The desired number of instances"
  type        = number
  default     = 1
}

variable "container_cpu" {
  description = "The number of CPU units (vCPU/1024) used by the task"
  type        = number
  default     = 512
}

variable "container_memory" {
  description = "The amount of RAM (in MiB) used by the task"
  type        = number
  default     = 1024
}

variable "container_memory_reservation" {
  description = "The amount of RAM (in MiB) to reserve for the container"
  type        = number
  default     = 512
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

variable "container_environment_secrets" {
  description = "List of secrets the container will use"
  type = list(object(
    {
      name      = string
      valueFrom = string
    }
  ))
  default = []
}

### VPC
variable "vpc_id" {
  description = "ID of an existing VPC where resources will be created."
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "A list of IDs of existing public subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "A list of IDs of existing private subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "health_check_path" {
  description = "The URI to the health check resource."
  type        = string
  default     = "/health"
}

variable "health_check_port" {
  description = "The PORT to the health check resource."
  type        = number
  default     = null
}

### DNS
variable "route53_zone_name" {
  description = "Route53 zone name"
  type        = string
  default     = ""
}

variable "route53_record_name" {
  description = "Name of Route53 record "
  type        = string
  default     = null
}

variable "create_route53_record" {
  description = "If create Route53 record for the service"
  type        = bool
  default     = true
}

### CDN
variable "create_cloud_front" {
  description = "Create Cloud Front distribution (CDN)"
  type        = bool
  default     = false
}

variable "policies_arn" {
  description = "A list of the ARN of the policies you want to apply"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}
