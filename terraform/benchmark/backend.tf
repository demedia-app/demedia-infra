terraform {
  backend "s3" {
    bucket         = "demedia-terraform"
    key            = "backends/benchmark/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "demedia-terraform-backend-locking"
    encrypt        = true
    profile        = "demedia-IAM"
  }
}