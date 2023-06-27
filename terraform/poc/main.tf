resource "aws_s3_bucket" "my-awesome-bucket" {
  bucket = "my-awesome-bucket-cb14"
  lifecycle {
    prevent_destroy = false
  }
}