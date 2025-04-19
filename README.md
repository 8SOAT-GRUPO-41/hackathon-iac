# Hackathon Infrastructure as Code

This repository contains Terraform code for provisioning AWS infrastructure for the FIAP Hackathon project.

## Project Structure

The project has been organized into logical components:

- `main.tf` - Main entry point for the Terraform configuration
- `data.tf` - Data sources used in the project
- `variables.tf` - Input variables definition
- `outputs.tf` - Output values from the infrastructure
- `providers.tf` - Provider configuration
- `network.tf` - VPC, subnets, internet gateway, NAT gateway, and route tables
- `eks.tf` - EKS cluster configuration
- `api_gateway.tf` - API Gateway configuration
- `s3.tf` - S3 bucket configuration
- `modules/` - Reusable Terraform modules

## Infrastructure Components

The infrastructure includes:

- VPC with public and private subnets
- Internet Gateway and NAT Gateway for outbound internet connectivity
- Amazon EKS cluster for container orchestration
- HTTP API Gateway for API management
- S3 Buckets for video storage and static website hosting

### S3 Buckets

Two S3 buckets are provisioned:

1. **Video Storage Bucket** (`${project_name}-video-bucket`)
   - Versioning enabled for file history
   - CORS configured to allow cross-origin requests
   - Lifecycle rules for transitioning to STANDARD-IA storage after 30 days
   - Automatic deletion of objects after 365 days
   - Server-side encryption with AES256

2. **Frontend Hosting Bucket** (`${project_name}-frontend-bucket`)
   - Configured for static website hosting
   - Index document: `index.html`
   - Error document: `index.html`
   - Public access enabled for website content
   - CORS configured to allow cross-origin requests
   - Versioning enabled for deployment rollbacks

## Usage

To use this Terraform configuration:

1. Make sure you have Terraform installed
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

## Variables

Key variables that can be customized:

- `aws_region`: AWS region to deploy resources (default: "us-east-1")
- `environment`: Environment name (default: "dev")
- `project_name`: Project name for resource naming (default: "hackathon-g41")
- `vpc_cidr`: CIDR block for the VPC (default: "10.0.0.0/16")
- `eks_cluster_version`: Kubernetes version (default: "1.31")
- `eks_node_instance_type`: Instance type for worker nodes (default: "t3.medium")

See `variables.tf` for more details.