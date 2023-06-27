terraform {
   backend "s3" {
     bucket = "demedia-terraform"
     key = "backends/ec2/prerequisites/terraform.tfstate"
     region = "us-east-1"
     dynamodb_table = "demedia-terraform-backend-locking"
     encrypt = true
     profile = "demedia-IAM"
   }
}