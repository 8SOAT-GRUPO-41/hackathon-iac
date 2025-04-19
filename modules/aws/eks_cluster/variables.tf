variable "cluster_name" {
  type = string
}

variable "private_subnets" {
  description = "VPC private subnets"
  type        = list(any)
}

variable "role_arn" {
  description = "The ARN of the role that provides permissions for the EKS cluster"
  type        = string
}
