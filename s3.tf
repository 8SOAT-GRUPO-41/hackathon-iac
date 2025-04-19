module "hackathon_video_bucket" {
  source = "./modules/aws/s3_bucket"
  
  bucket_name = "${var.project_name}-video-bucket"
  environment = var.environment
  enable_versioning = true
  enable_cors = true
  cors_allowed_origins = ["*"]
}

module "hackathon_frontend_bucket" {
  source = "./modules/aws/s3_bucket"
  
  bucket_name = "${var.project_name}-frontend-bucket"
  environment = var.environment
  enable_versioning = true
  enable_cors = true
  cors_allowed_origins = ["*"]
  website = true
  index_document = "index.html"
  error_document = "index.html"
}
