terraform {
  #required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.3.0"
    }
  }
}

provider "aws" {
  profile = "personal"
  region  = var.terraform_provider_region
}