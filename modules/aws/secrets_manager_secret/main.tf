resource "aws_secretsmanager_secret" "this" {
  name                           = var.name
  description                    = var.description
  kms_key_id                     = var.kms_key_id
  recovery_window_in_days        = 7
  force_overwrite_replica_secret = true
  tags                           = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_string
  lifecycle {
    # Prevent destroying the secret version accidentally without intent:
    prevent_destroy = false
  }
}

locals {
  rotation_rules = {
    automatically_after_days = var.rotation_days
  }

  # If using rotation interval (like 30d), you can choose one or the other:
  # If rotation_interval is preferred, you can remove rotation_days logic
  # and just rely on `rotation_interval` in a future provider version 
  # (depending on provider's fields).
}

resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.enable_rotation && var.rotation_lambda_arn != null ? 1 : 0

  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = var.rotation_lambda_arn

  # Use either rotation_days or a custom rule; depending on Terraform provider:
  # Many providers support automatically_after_days directly:
  rotation_rules {
    automatically_after_days = local.rotation_rules.automatically_after_days
  }

  # If you have a newer provider that supports rotation_interval (like '30d'), use:
  # rotation_rules {
  #   duration = var.rotation_interval
  # }
}
