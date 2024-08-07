
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.1"
    }
  }

}

resource "aws_s3_bucket" "obi-test-bucket" {
  bucket_prefix = regex("[a-z0-9.-]+", "-obi-app")
  force_destroy = true
}