#######################################
# VPC
#######################################
module "hackathon_vpc" {
  source     = "./modules/aws/vpc"
  cidr_block = var.vpc_cidr
  name       = "${var.project_name}-vpc"
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
  name                    = "${var.project_name}-db-private-subnet-a"
  availability_zone       = "${var.aws_region}a"

  tags = {
    "Name"        = "${var.project_name}-db-private-subnet-a"
    "Environment" = var.environment
  }
}

module "hackathon_db_private_subnet_b" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.102.0/24"
  map_public_ip_on_launch = false
  name                    = "${var.project_name}-db-private-subnet-b"
  availability_zone       = "${var.aws_region}b"

  tags = {
    "Name"        = "${var.project_name}-db-private-subnet-b"
    "Environment" = var.environment
  }
}

# Private Subnet for EKS
module "hackathon_eks_private_subnet_a" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  name                    = "${var.project_name}-eks-private-subnet-a"
  availability_zone       = "${var.aws_region}a"

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "Name"                            = "${var.project_name}-eks-private-subnet-a"
    "Environment"                     = var.environment
  }
}

module "hackathon_eks_private_subnet_b" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  name                    = "${var.project_name}-eks-private-subnet-b"
  availability_zone       = "${var.aws_region}b"

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "Name"                            = "${var.project_name}-eks-private-subnet-b"
    "Environment"                     = var.environment
  }
}

# Public Subnet for NAT Gateway and Internet Access
module "hackathon_public_subnet_a" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  name                    = "${var.project_name}-public-subnet-a"
  availability_zone       = "${var.aws_region}a"
  tags = {
    "kubernetes.io/role/elb" = "1"
    "Name"                   = "${var.project_name}-public-subnet-a"
    "Environment"            = var.environment
  }
}

module "hackathon_public_subnet_b" {
  source                  = "./modules/aws/subnet"
  vpc_id                  = module.hackathon_vpc.vpc_id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
  name                    = "${var.project_name}-public-subnet-b"
  availability_zone       = "${var.aws_region}b"
  tags = {
    "kubernetes.io/role/elb" = "1"
    "Name"                   = "${var.project_name}-public-subnet-b"
    "Environment"            = var.environment
  }
}

#######################################
# Internet Gateway
#######################################
module "internet_gateway" {
  source = "./modules/aws/internet_gateway"
  vpc_id = module.hackathon_vpc.vpc_id
  name   = "${var.project_name}-public-igw"
}

#######################################
# NAT Gateway - in Public Subnet
#######################################
module "nat_gateway" {
  source    = "./modules/aws/nat_gateway"
  subnet_id = module.hackathon_public_subnet_a.subnet_id
  name      = "${var.project_name}-nat-gw"
}

#######################################
# Route Tables
#######################################
# Public Route Table
module "hackathon_public_rt" {
  source = "./modules/aws/route_table"
  vpc_id = module.hackathon_vpc.vpc_id
  name   = "${var.project_name}-public-rt"
}

# Private Route Table (for both DB and EKS)
module "hackathon_private_rt" {
  source = "./modules/aws/route_table"
  vpc_id = module.hackathon_vpc.vpc_id
  name   = "${var.project_name}-private-rt"
}

#######################################
# Routes
#######################################
# Public route to internet
resource "aws_route" "hackathon_public_inet_route" {
  route_table_id         = module.hackathon_public_rt.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.internet_gateway.internet_gateway_id
}

# Private route via NAT Gateway
resource "aws_route" "hackathon_private_inet_route" {
  route_table_id         = module.hackathon_private_rt.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.nat_gateway.nat_gateway_id
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