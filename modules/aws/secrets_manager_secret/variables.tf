variable "name" {
  type        = string
  description = "The name of the secret."
}

variable "description" {
  type        = string
  description = "Description of the secret."
  default     = null
}

variable "secret_string" {
  type        = string
  description = "The secret value to store in Secrets Manager."
}

variable "kms_key_id" {
  type        = string
  description = "The ARN or Id of the AWS KMS key to use for encrypting the secret."
  default     = null
}

variable "enable_rotation" {
  type        = bool
  description = "Set to true to enable rotation for the secret."
  default     = false
}

variable "rotation_lambda_arn" {
  type        = string
  description = "The ARN of the Lambda function that rotates the secret. Required if rotation is enabled."
  default     = null
}

variable "rotation_interval" {
  type        = string
  description = "How often Secrets Manager rotates the secret, for example: 30d, 7d."
  default     = "30d"
}

variable "rotation_days" {
  type        = number
  description = "Number of days after the previous rotation before Secrets Manager rotates the secret again. If rotation_interval is not used."
  default     = null
}

# Optional tags for consistency across environments
variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the secret."
  default     = {}
}
