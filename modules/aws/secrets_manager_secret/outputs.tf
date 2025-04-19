output "secret_arn" {
  description = "The ARN of the Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_id" {
  description = "The ID of the Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.id
}

output "current_secret_version_id" {
  description = "The version ID of the currently active secret."
  value       = aws_secretsmanager_secret_version.this.version_id
}
