variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "node_group_name" {
  type        = string
  description = "The name of the EKS node group"
}

variable "node_role_arn" {
  type        = string
  description = "The ARN of the IAM role to associate with the EKS node group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The private subnets to launch the EKS node group into"
}

variable "desired_size" {
  type        = number
  description = "The desired number of worker nodes"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "The maximum number of worker nodes"
  default     = 2
}

variable "min_size" {
  type        = number
  description = "The minimum number of worker nodes"
  default     = 1
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the EKS node group"
}

variable "disk_size" {
  type        = number
  description = "The size of the EBS volume to attach to each worker node"
  default     = 20
}
