resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_name}-${var.enviroment}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = local.private_subnet_ids
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

resource "kubernetes_namespace" "eks_namespace" {
  metadata {
    name = var.k8s_namespace
  }
}

resource "kubernetes_namespace" "eks_logging_namespace" {
  metadata {
    name = "aws-observability"
    labels = {
      aws-observability: "enabled"
    }
  }
}

resource "aws_iam_openid_connect_provider" "cluster" {
  depends_on = [
    data.tls_certificate.oidc_tls_certificate
  ]
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_tls_certificate.certificates.0.sha1_fingerprint]
  url = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}

# EKS Cluster Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# EKS Access entries - workload admin
resource "aws_eks_access_entry" "eks_admin_access_entry" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = local.iam_admin_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_admin_policy_association" {
  depends_on = [
    aws_eks_access_entry.eks_admin_access_entry
  ]
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = local.iam_admin_arn

  access_scope {
    type       = "cluster"
  }
}

# EKS Access entries - deployer role
resource "aws_eks_access_entry" "eks_deployer_access_entry" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = data.terraform_remote_state.dev_tier0.outputs.app_deployer_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_deployer_policy_association" {
  depends_on = [
    aws_eks_access_entry.eks_deployer_access_entry
  ]
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.terraform_remote_state.dev_tier0.outputs.app_deployer_role_arn

  access_scope {
    type       = "cluster"
  }
}