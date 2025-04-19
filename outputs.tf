# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.hackathon_vpc.vpc_id
}

# Subnets
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value = [
    module.hackathon_public_subnet_a.subnet_id,
    module.hackathon_public_subnet_b.subnet_id
  ]
}

output "eks_private_subnet_ids" {
  description = "IDs of the EKS private subnets"
  value = [
    module.hackathon_eks_private_subnet_a.subnet_id,
    module.hackathon_eks_private_subnet_b.subnet_id
  ]
}

output "db_private_subnet_ids" {
  description = "IDs of the DB private subnets"
  value = [
    module.hackathon_db_private_subnet_a.subnet_id,
    module.hackathon_db_private_subnet_b.subnet_id
  ]
}

# EKS
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for the EKS cluster API server"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ID for the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

# API Gateway
output "api_gateway_endpoint" {
  description = "API Gateway endpoint URL"
  value       = module.hackathon_http_api.api_endpoint
}

output "video_processing_queue_url" {
  description = "Video processing queue URL"
  value       = module.video_processing_queue.queue_url
}

output "video_processing_queue_arn" {
  description = "Video processing queue ARN"
  value       = module.video_processing_queue.queue_arn
}

