terraform {
   backend "s3" {
     bucket = "demedia-terraform"
     key = "terraform/demedia/backend/terraform_init.tfstate"
     region = "us-east-1"
     dynamodb_table = "demedia-terraform-backend-locking"
     encrypt = true
   }
}