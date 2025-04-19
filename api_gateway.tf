#######################################
# HTTP API Gateway
#######################################
module "hackathon_http_api" {
  source              = "./modules/aws/http_api_gateway"
  name                = "${var.project_name}-http-api"
  vpc_link_name       = "${var.project_name}-vpc-link"
  vpc_link_subnet_ids = [module.hackathon_eks_private_subnet_a.subnet_id]
  protocol_type       = "HTTP"
  stage_name          = "$default"

  tags = {
    Name        = "${var.project_name}-http-api"
    Provisioner = "Terraform"
    Environment = var.environment
  }
} 