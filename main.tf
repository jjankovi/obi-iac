
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.1"
    }
  }

}

provider "aws" {
  region  = "eu-central-1"
}

resource "aws_instance" "example" {
  ami  = "ami-00060fac2f8c42d30"
  instance_type = "t2.micro"
}