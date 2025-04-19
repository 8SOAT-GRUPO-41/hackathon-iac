resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Provisioner = "Terraform"
  }

  # Inline website block only when website = true
  dynamic "website" {
    for_each = var.website ? [1] : []
    content {
      index_document = var.index_document
      error_document = var.error_document
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  # If this is a public website bucket, we must allow public policies
  block_public_acls       = var.website ? false : true
  ignore_public_acls      = var.website ? false : true
  block_public_policy     = var.website ? false : true
  restrict_public_buckets = var.website ? false : true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "lifecycle-rule"
    status = "Enabled"

    transition {
      days          = var.transition_days
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = var.expiration_days
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count  = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.this.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = var.cors_allowed_origins
    expose_headers  = ["ETag", "Content-Length", "Content-Type"]
    max_age_seconds = 3000
  }
}

# Only for website buckets: allow public GET on all objects
resource "aws_s3_bucket_policy" "public_read" {
  count   = var.website ? 1 : 0
  bucket  = aws_s3_bucket.this.id

  # ensure the public‐access block has already been relaxed
  depends_on = [ aws_s3_bucket_public_access_block.this ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}
