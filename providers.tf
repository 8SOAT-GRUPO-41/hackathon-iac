terraform {
  cloud {
    organization = "FIAP-Hackathon-G41"

    workspaces {
      name = "hackathon-iac"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
