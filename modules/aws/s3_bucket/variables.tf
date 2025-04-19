variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment tag for the S3 bucket"
  type        = string
  default     = "production"
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

variable "transition_days" {
  description = "Number of days before transitioning objects to STANDARD_IA storage class"
  type        = number
  default     = 30
}

variable "expiration_days" {
  description = "Number of days before objects expire"
  type        = number
  default     = 365
}

variable "enable_cors" {
  description = "Enable CORS for the S3 bucket"
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}
