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
    bucket  = "portafolio-cloud-s3" # El nombre de tu bucket existente
    key     = "projects/aws-portfolio/terraform.tfstate"
    region  = "us-east-1" # La región donde está tu bucket
    encrypt = true
    # Opcional: dynamodb_table = "tu-tabla-lock"     # Si tienes una tabla para State Locking
    profile = "aws-idel"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "aws-idel"

  default_tags {
    tags = {
      Environment = "Portfolio"
      Owner       = "CloudEngineer"
      Terraform   = "true"
      Project     = "Scalable-Infrastructure"
    }
  }
}
