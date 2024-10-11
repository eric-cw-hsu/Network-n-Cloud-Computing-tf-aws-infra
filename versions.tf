terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 5.45, != 5.71.0"
    }
  }

  required_version = ">= 1.9.0"
}
