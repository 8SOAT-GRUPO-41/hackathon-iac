resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.role_arn
  version  = "1.31"

  vpc_config {
    subnet_ids = var.private_subnets
  }
}
