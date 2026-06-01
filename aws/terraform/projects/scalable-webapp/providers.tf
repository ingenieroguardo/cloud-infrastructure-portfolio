terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Configuración del Backend Remoto
  backend "s3" {
    bucket         = "portafolio-cloud-s3-idel"
    key            = "projects/aws-portfolio/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    profile        = "terraform"
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform"

  default_tags {
    tags = {
      Environment = "Portfolio"
      Owner       = "CloudEngineer"
      Terraform   = "true"
      Project     = "Scalable-Infrastructure"
    }
  }
}
