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

############################################
# Create API Gateway Integration
############################################

resource "aws_apigatewayv2_integration" "backend_integration" {
  api_id             = module.hackathon_http_api.api_id
  integration_type   = "HTTP_PROXY"
  integration_uri    = data.aws_lb_listener.backend_listener.arn
  connection_type    = "VPC_LINK"
  connection_id      = module.hackathon_http_api.vpc_link_id
  integration_method = "ANY"
}

############################################
# BACKEND ROUTES
############################################
resource "aws_apigatewayv2_route" "backend_route" {
  api_id    = module.hackathon_http_api.api_id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.backend_integration.id}"
}
