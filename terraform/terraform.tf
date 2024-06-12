terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "uti-terraform-tf-state"
    key    = "cloudflare-logging/terraform.tfstate"
    region = "us-east-1"
  }
}

# default provider
provider "aws" {}
provider "aws" {
  alias  = "app"
  region = var.app_region
}

provider "aws" {
  alias  = "kafka"
  region = var.kafka_region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}