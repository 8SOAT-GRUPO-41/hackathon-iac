#######################################
# Data Sources
#######################################
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

#######################################
# VPC
#######################################
module "hackathon_vpc" {
  source     = "./modules/aws/vpc"
  cidr_block = "10.0.0.0/16"
  name       = "hackathon-vpc"
}

#######################################
# Subnets
#######################################

# Private Subnet for DB
module "hackathon_db_private_subnet_a" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = false
  name                    = "hackathon-db-private-subnet-a"
  availability_zone       = "us-east-1a"

  tags = {
    "Name" = "hackathon-db-private-subnet-a"
  }
}

module "hackathon_db_private_subnet_b" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.102.0/24"
  map_public_ip_on_launch = false
  name                    = "hackathon-db-private-subnet-b"
  availability_zone       = "us-east-1b"

  tags = {
    "Name" = "hackathon-db-private-subnet-b"
  }
}

# Private Subnet for EKS
module "hackathon_eks_private_subnet_a" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  name                    = "hackathon-eks-private-subnet-a"
  availability_zone       = "us-east-1a"

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "Name"                            = "hackathon-eks-private-subnet-a"
  }
}

module "hackathon_eks_private_subnet_b" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  name                    = "hackathon-eks-private-subnet-b"
  availability_zone       = "us-east-1b"

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "Name"                            = "hackathon-eks-private-subnet-b"
  }
}

# Public Subnet for NAT Gateway and Internet Access
module "hackathon_public_subnet_a" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  name                    = "hackathon-public-subnet-a"
  availability_zone       = "us-east-1a"
  tags = {
    "kubernetes.io/role/elb" = "1"
    "Name"                   = "hackathon-public-subnet-a"
  }
}
# Public Subnet for NAT Gateway and Internet Access
module "hackathon_public_subnet_b" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
  name                    = "hackathon-public-subnet-b"
  availability_zone       = "us-east-1b"
  tags = {
    "kubernetes.io/role/elb" = "1"
    "Name"                   = "hackathon-public-subnet-b"
  }
}

#######################################
# Route Tables
#######################################
# Public Route Table
module "hackathon_public_rt" {
  source = "./modules/aws/route_table"
  vpc_id = module.hackathon_vpc.vpc_id
  name   = "hackathon-public-rt"
}

# Private Route Table (for both DB and EKS)
module "hackathon_private_rt" {
  source = "./modules/aws/route_table"
  vpc_id = module.hackathon_vpc.vpc_id
  name   = "hackathon-private-rt"
}

#######################################
# Route Table Associations
#######################################
# Associate DB subnet with private RT
resource "aws_route_table_association" "hackathon_private_rta_db_a" {
  subnet_id      = module.hackathon_db_private_subnet_a.subnet_id
  route_table_id = module.hackathon_private_rt.route_table_id
}

resource "aws_route_table_association" "hackathon_private_rtb_db_b" {
  subnet_id      = module.hackathon_db_private_subnet_b.subnet_id
  route_table_id = module.hackathon_private_rt.route_table_id
}

# Associate EKS subnet with private RT
resource "aws_route_table_association" "eks_private_rta" {
  subnet_id      = module.hackathon_eks_private_subnet_a.subnet_id
  route_table_id = module.hackathon_private_rt.route_table_id
}

resource "aws_route_table_association" "eks_private_rtb" {
  subnet_id      = module.hackathon_eks_private_subnet_b.subnet_id
  route_table_id = module.hackathon_private_rt.route_table_id
}

# Associate Public subnet with public RT
resource "aws_route_table_association" "hackathon_public_rta" {
  subnet_id      = module.hackathon_public_subnet_a.subnet_id
  route_table_id = module.hackathon_public_rt.route_table_id
}

resource "aws_route_table_association" "hackathon_public_rtb" {
  subnet_id      = module.hackathon_public_subnet_b.subnet_id
  route_table_id = module.hackathon_public_rt.route_table_id
}

#######################################
# HTTP API Gateway
#######################################
module "hackathon_http_api" {
  source              = "./modules/aws/http_api_gateway"
  name                = "hackathon-http-api"
  vpc_link_name       = "hackathon-vpc-link"
  vpc_link_subnet_ids = [module.hackathon_eks_private_subnet_a.subnet_id]
  protocol_type       = "HTTP"
  stage_name          = "$default"

  tags = {
    Name        = "hackathon-http-api"
    Provisioner = "Terraform"
  }
}

#######################################
# EKS Cluster
#######################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.1.0"

  cluster_name    = "hackathon-g41-cluster"
  cluster_version = "1.31"

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
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    hackathon = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1

      create_iam_role = false
      iam_role_arn    = data.aws_iam_role.lab_role.arn
    }
  }

  tags = {
    Provisioner = "Terraform"
  }
}