# AWS S3 Bucket Module for Video Storage

This Terraform module creates an S3 bucket optimized for video storage with configurable versioning, lifecycle rules, encryption, and CORS settings. The module supports generating pre-signed URLs from your backend for secure video uploads and downloads.

## Features

- Basic S3 bucket creation with proper naming and tagging
- Optional versioning
- Server-side encryption with AES256
- Lifecycle rules for transitioning videos to Standard-IA storage and eventual expiration
- Optional CORS configuration for web access
- Configured for use with pre-signed URLs
- Public access blocked by default for enhanced security

## Usage

```hcl
module "video_storage" {
  source = "./modules/aws/s3_bucket"

  bucket_name = "my-video-storage-bucket"
  environment = "production"
  
  # Optional configurations
  enable_versioning = true
  transition_days   = 30  # Move to STANDARD_IA after 30 days
  expiration_days   = 365 # Delete after 1 year
  
  # CORS configuration (for web apps using pre-signed URLs)
  enable_cors         = true
  cors_allowed_origins = ["https://example.com"]
}
```

## Examples

### Basic Usage

```hcl
module "video_bucket" {
  source = "./modules/aws/s3_bucket"
  
  bucket_name = "video-content-bucket"
}
```

### With Lifecycle Management and Versioning

```hcl
module "video_archive" {
  source = "./modules/aws/s3_bucket"
  
  bucket_name       = "video-archive-bucket"
  environment       = "staging"
  enable_versioning = true
  transition_days   = 90
  expiration_days   = 730 # 2 years
}
```

### With CORS Enabled for Web Applications Using Pre-Signed URLs

```hcl
module "web_video_bucket" {
  source = "./modules/aws/s3_bucket"
  
  bucket_name         = "web-video-bucket"
  enable_cors         = true
  cors_allowed_origins = ["https://example.com", "https://www.example.com"]
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | The name of the S3 bucket | `string` | n/a | yes |
| environment | Environment tag for the S3 bucket | `string` | `"production"` | no |
| enable_versioning | Enable versioning for the S3 bucket | `bool` | `false` | no |
| transition_days | Number of days before transitioning objects to STANDARD_IA storage class | `number` | `30` | no |
| expiration_days | Number of days before objects expire | `number` | `365` | no |
| enable_cors | Enable CORS for the S3 bucket | `bool` | `false` | no |
| cors_allowed_origins | List of allowed origins for CORS | `list(string)` | `["*"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The name of the bucket |
| bucket_arn | The ARN of the bucket |
| bucket_domain_name | The bucket domain name |
| bucket_regional_domain_name | The bucket region-specific domain name |

## Using Pre-Signed URLs with this Module

This module is configured to work seamlessly with pre-signed URLs. Here's how to generate and use them in your backend:

### Setting Up IAM Permissions

First, create an IAM policy and attach it to your backend service:

```hcl
resource "aws_iam_policy" "s3_presigned_url_policy" {
  name   = "s3-presigned-url-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ],
        Effect   = "Allow",
        Resource = "${module.video_bucket.bucket_arn}/*"
      }
    ]
  })
}
```

### Generating Pre-Signed URLs (Node.js Example)

```javascript
import { S3Client, PutObjectCommand, GetObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

const s3Client = new S3Client({ region: "your-region" });

// Generate upload URL (expires in 15 minutes)
async function generateUploadUrl(fileName, contentType) {
  const command = new PutObjectCommand({
    Bucket: "your-bucket-name",
    Key: fileName,
    ContentType: contentType
  });
  
  return getSignedUrl(s3Client, command, { expiresIn: 900 });
}

// Generate download URL (expires in 1 hour)
async function generateDownloadUrl(fileName) {
  const command = new GetObjectCommand({
    Bucket: "your-bucket-name",
    Key: fileName
  });
  
  return getSignedUrl(s3Client, command, { expiresIn: 3600 });
}
```

### Front-End Usage Example

```javascript
// For uploading
async function uploadVideo(file) {
  // Get pre-signed URL from your backend
  const response = await fetch('/api/get-upload-url?filename=video.mp4&contentType=video/mp4');
  const { uploadUrl } = await response.json();
  
  // Use the pre-signed URL to upload directly to S3
  await fetch(uploadUrl, {
    method: 'PUT',
    body: file,
    headers: {
      'Content-Type': 'video/mp4'
    }
  });
}

// For downloading/streaming
async function getVideoUrl(videoId) {
  const response = await fetch(`/api/get-download-url?videoId=${videoId}`);
  const { downloadUrl } = await response.json();
  
  // Use this URL in a video player or download link
  return downloadUrl;
}
```

This approach provides secure, temporary access to upload and download videos without making your bucket public or requiring AWS credentials in your front-end code. 