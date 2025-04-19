output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}

output "node_group_arn" {
  value = aws_eks_node_group.this.arn
}

output "node_group_id" {
  value = aws_eks_node_group.this.id
}

output "node_group_status" {
  value = aws_eks_node_group.this.status
}

output "node_group_version" {
  value = aws_eks_node_group.this.version
}

output "node_group_cluster_name" {
  value = aws_eks_node_group.this.cluster_name
}

output "node_group_node_role_arn" {
  value = aws_eks_node_group.this.node_role_arn
}
