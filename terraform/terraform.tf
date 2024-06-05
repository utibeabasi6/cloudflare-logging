terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "uti-terraform-tf-state"
    key    = "cloudflare-logging/terraform.tfstate"
    region = "us-east-1"
  }
}