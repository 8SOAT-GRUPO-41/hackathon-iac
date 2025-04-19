terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47.0"
    }
  }

  cloud {
    organization = "FIAP-Hackathon-G41"

    workspaces {
      name = "hackathon-iac"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
