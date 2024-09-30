data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "terraform_remote_state" "dev_tier0" {
  backend = "s3"
  config = {
    bucket         = "csob-dev-terraform-state"
    dynamodb_table = "csob-dev-terraform-state-lock"
    key            = "tier0.init.terraform.tfstate"
    encrypt        = true
    region         = "eu-central-1"
  }
}

data "tls_certificate" "oidc_tls_certificate" {
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
  url = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}