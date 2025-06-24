terraform {
  backend "s3" {
    bucket  = "iac-tfbackend"
    key     = "dev-infrastructure.tfstate"
    region  = "us-east-1"
    profile = "personal"
  }
}