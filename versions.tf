terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.19"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
  }
}
