output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "cluster_version" {
  value = aws_eks_cluster.this.version
}

output "cluster_role_arn" {
  value = aws_eks_cluster.this.role_arn
}

output "cluster_created_at" {
  value = aws_eks_cluster.this.created_at
}
