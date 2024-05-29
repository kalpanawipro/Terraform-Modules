variable "vpc_id" {
  description = "The ID of the VPC where subnets will be created"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = data.aws_availability_zones.available.names
}
