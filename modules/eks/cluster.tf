#data "terraform_remote_state" "vpc" {
#  backend = "s3"
#
#  config = {
#    bucket = "your-terraform-state-bucket"
#    key    = "vpc/terraform.tfstate"
#    region = "eu-central-1"
#  }
#}

locals {
  subnet_ids = ["subnet-0dd23e7d3721f282a", "subnet-023be89ffd730a525", "subnet-098a3d68ae40c62f6"]
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_name}-${var.enviroment}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
#    subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids
    subnet_ids = local.subnet_ids
  }
}

resource "aws_eks_fargate_profile" "fargate_profile" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  fargate_profile_name = "${var.project_name}-fargate-profile"

  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn

#  subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids
  subnet_ids = local.subnet_ids

  selector {
    namespace = var.k8s_namespace
  }
}

resource "aws_eks_addon" "alb_ingress" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "alb-ingress-controller"
}
