variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Tag for environment"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = false
}

variable "enable_cors" {
  description = "Whether to enable CORS"
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "List of allowed CORS origins"
  type        = list(string)
  default     = []
}

variable "transition_days" {
  description = "Days before transitioning to STANDARD_IA"
  type        = number
  default     = 30
}

variable "expiration_days" {
  description = "Days before object expiration"
  type        = number
  default     = 365
}

variable "website" {
  description = "Create as a static‑website bucket if true"
  type        = bool
  default     = false
}

variable "index_document" {
  description = "Index document for website hosting"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document for website hosting"
  type        = string
  default     = "error.html"
}