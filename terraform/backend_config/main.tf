#backend.tf
provider "aws" {
  region = "us-east-1"
  profile = "demedia-IAM"
}

resource "aws_s3_bucket" "tf_remote_state" {
  bucket = "demedia-terraform"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning_enable" {
  bucket = aws_s3_bucket.tf_remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.tf_remote_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

#locking part
resource "aws_dynamodb_table" "tf_remote_state_locking" {
  hash_key = "LockID"
  name = "demedia-terraform-backend-locking"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}