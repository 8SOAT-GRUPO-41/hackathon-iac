variable "name" {
  type        = string
  description = "Name of the API Gateway HTTP API"
}

variable "protocol_type" {
  type        = string
  default     = "HTTP"
  description = "Protocol type for the API. Valid values: HTTP, WEBSOCKET"
}

variable "stage_name" {
  type        = string
  default     = "$default"
  description = "Name of the stage. Use '$default' for the default stage."
}

variable "auto_deploy" {
  type        = bool
  default     = true
  description = "Indicates whether changes to an API should be deployed automatically."
}

variable "access_log_destination_arn" {
  type        = string
  default     = null
  description = "ARN of the log destination for the access logs. If null, no logging is configured."
}

variable "access_log_format" {
  type        = string
  default     = "$context.requestId $context.integrationErrorMessage"
  description = "Format of the access logs if enabled."
}

variable "default_route_throttling_burst_limit" {
  type        = number
  default     = 1000
  description = "Throttling burst limit for the default route."
}

variable "default_route_throttling_rate_limit" {
  type        = number
  default     = 1000
  description = "Throttling rate limit for the default route."
}

variable "cors_allow_origins" {
  type        = list(string)
  default     = []
  description = "List of allowed origins for CORS."
}

variable "cors_allow_methods" {
  type        = list(string)
  default     = []
  description = "List of allowed methods for CORS."
}

variable "cors_allow_headers" {
  type        = list(string)
  default     = []
  description = "List of allowed headers for CORS."
}

variable "cors_expose_headers" {
  type        = list(string)
  default     = []
  description = "List of headers exposed by the CORS configuration."
}

variable "cors_max_age" {
  type        = number
  default     = null
  description = "How long the results of a preflight request can be cached."
}

variable "vpc_link_name" {
  type        = string
  default     = null
  description = "Name of the VPC link."
}

variable "vpc_link_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet IDs for the VPC link."
}

variable "vpc_link_security_group_ids" {
  type        = list(string)
  default     = []
  description = "List of security group IDs for the VPC link."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to assign to the resource."
}
