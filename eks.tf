#######################################
# EKS Cluster
#######################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.1.0"

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = var.eks_cluster_version

  create_iam_role = false
  iam_role_arn    = data.aws_iam_role.lab_role.arn
  enable_irsa     = false

  vpc_id = module.hackathon_vpc.vpc_id

  subnet_ids = [
    module.hackathon_eks_private_subnet_a.subnet_id,
    module.hackathon_eks_private_subnet_b.subnet_id
  ]
  control_plane_subnet_ids = [
    module.hackathon_eks_private_subnet_a.subnet_id,
    module.hackathon_eks_private_subnet_b.subnet_id
  ]

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    instance_types = [var.eks_node_instance_type]
  }

  eks_managed_node_groups = {
    hackathon = {
      instance_types = [var.eks_node_instance_type]
      min_size       = var.eks_node_min_capacity
      max_size       = var.eks_node_max_capacity
      desired_size   = var.eks_node_desired_capacity

      create_iam_role = false
      iam_role_arn    = data.aws_iam_role.lab_role.arn
    }
  }

  tags = {
    Provisioner = "Terraform"
    Environment = var.environment
  }
} 