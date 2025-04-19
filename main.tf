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