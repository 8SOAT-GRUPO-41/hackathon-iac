# AWS Secrets Manager Secret Module

This module creates and manages an AWS Secrets Manager secret. It supports:
- Creating a new secret.
- Managing a secret version for the current secret value.
- Optionally enabling rotation with a specified rotation Lambda.

## Example Usage

```hcl
module "db_password_secret" {
  source           = "./modules/aws/secrets_manager_secret"
  name             = "my-database-password"
  secret_string    = "supersecurepassword!"
  enable_rotation  = true
  rotation_lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:MyRotationFunction"
  rotation_days    = 30
  tags = {
    Environment = "dev"
    Project     = "my-app"
  }
}
```