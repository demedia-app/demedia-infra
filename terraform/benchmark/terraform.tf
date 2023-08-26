terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# default the AWS Provider
provider "aws" {
  profile = "demedia-IAM"
  region  = "us-east-1"
}

#provider for us-east-1
provider "aws" {
  profile = "demedia-IAM"
  region  = "us-east-1"
  alias   = "us-east-1"
}

#provider for us-west-2
provider "aws" {
  profile = "demedia-IAM"
  region  = "us-west-1"
  alias   = "us-west-1"
}

#provider for ap-south-1
provider "aws" {
  profile = "demedia-IAM"
  region  = "ap-south-1"
  alias   = "ap-south-1"
}