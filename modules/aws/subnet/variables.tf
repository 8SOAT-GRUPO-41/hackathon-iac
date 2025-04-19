variable "vpc_id" {
  description = "VPC ID to create the subnet in"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Whether to map public IP on launch"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name tag for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the subnet"
  type        = map(string)
  default     = {}
}
