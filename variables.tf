# Variables for the Hackathon infrastructure

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name to be used for resource naming"
  type        = string
  default     = "hackathon-g41"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "eks_node_instance_type" {
  description = "Instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "eks_node_desired_capacity" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 1
}

variable "eks_node_min_capacity" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 1
}

variable "eks_node_max_capacity" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 2
}

variable "backend_nlb_name" {
  description = "Name of the NLB for the backend service"
  type        = string
}

variable "rds_username" {
  description = "Username for the RDS instance"
  type        = string
}

variable "rds_password" {
  description = "Password for the RDS instance"
  type        = string
}

variable "rds_db_name" {
  description = "Name of the RDS database"
  type        = string
}
