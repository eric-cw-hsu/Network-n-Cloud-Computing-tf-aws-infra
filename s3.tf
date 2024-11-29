resource "random_uuid" "s3_bucket_name" {}

resource "aws_s3_bucket" "csye6225-s3-bucket" {
  bucket = random_uuid.s3_bucket_name.result
}

resource "aws_s3_bucket_versioning" "csye6225-s3-bucket-versioning" {
  bucket = aws_s3_bucket.csye6225-s3-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "csye6225-s3-bucket-lifecycle" {
  bucket = aws_s3_bucket.csye6225-s3-bucket.id

  rule {
    id     = "lifecycle_rule"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "csye6225-s3-bucket-server-side-encryption" {
  bucket = aws_s3_bucket.csye6225-s3-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
