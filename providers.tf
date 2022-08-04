terraform {
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17"
    }

    helm = {
      version = "~> 2.4"
    }
  }
}