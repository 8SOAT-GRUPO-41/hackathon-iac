resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  protocol_type = var.protocol_type

  # Optional CORS configuration
  cors_configuration {
    allow_origins  = var.cors_allow_origins
    allow_methods  = var.cors_allow_methods
    allow_headers  = var.cors_allow_headers
    expose_headers = var.cors_expose_headers
    max_age        = var.cors_max_age
  }

  tags = var.tags
}

resource "aws_apigatewayv2_stage" "this" {
  depends_on  = [aws_apigatewayv2_api.this]
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = var.auto_deploy

  default_route_settings {
    throttling_burst_limit = var.default_route_throttling_burst_limit
    throttling_rate_limit  = var.default_route_throttling_rate_limit
  }
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name       = var.vpc_link_name
  subnet_ids = var.vpc_link_subnet_ids

  security_group_ids = var.vpc_link_security_group_ids

  tags = var.tags
}

# TODO:
# 1. Subir uma rota
# 2. Subir uma integração (EKS)
# 3. Subir um autorizador (Lambda)

# Example integration with a Lambda function or EKS service:
# resource "aws_apigatewayv2_integration" "backend_integration" {
#   api_id = aws_apigatewayv2_api.this.id
#   integration_type = "HTTP_PROXY"
#   integration_uri  = var.backend_integration_uri
# }

# Example route configuration:
# resource "aws_apigatewayv2_route" "example_route" {
#   api_id    = aws_apigatewayv2_api.this.id
#   route_key = "GET /"
#   target    = "integrations/${aws_apigatewayv2_integration.backend_integration.id}"
#
#   # If using authorizers in the future:
#   # authorization_type = "CUSTOM"
#   # authorizer_id      = aws_apigatewayv2_authorizer.lambda_authorizer.id
# }
