locals {
  oidc_provider_id = "${replace(aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer, "https://", "")}"
  ingress_service_account_name = "aws-load-balancer-controller"
}

# IAM Role for the ALB Ingress Controller
resource "aws_iam_role" "alb_ingress_role" {
  name = "${var.project_name}-alb-ingress-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider_id}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${local.oidc_provider_id}:sub" = "system:serviceaccount:kube-system:${local.ingress_service_account_name}"
        }
      }
    }]
  })
}

# Kubernetes service account for ALB Ingress Controller
resource "kubernetes_service_account" "alb_ingress_sa" {
  metadata {
    name      = "${local.ingress_service_account_name}"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_ingress_role.arn
    }
  }
}

# Create IAM Policy for ALB Ingress Controller
data "aws_iam_policy_document" "alb_ingress_controller_policy_doc" {
  statement {
    actions = [
      "*"
    ]
    resources = ["*"]
  }
}

# Attach the ALB Ingress IAM policy
resource "aws_iam_policy" "alb_ingress_controller_policy" {
  name        = "${var.project_name}-alb-ingress-controller-policy"
  description = "IAM policy for ALB Ingress Controller"
  policy      = data.aws_iam_policy_document.alb_ingress_controller_policy_doc.json
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "alb_ingress_policy_attachment" {
  role       = aws_iam_role.alb_ingress_role.name
  policy_arn = aws_iam_policy.alb_ingress_controller_policy.arn
}

resource "helm_release" "aws_lb_controller" {
  depends_on = [
    aws_eks_fargate_profile.fargate_profile,
    kubernetes_config_map.cloudwatch_config_map
  ]
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eks_cluster.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb_ingress_sa.metadata[0].name
  }

  set {
    name  = "region"
    value = data.aws_region.current.name
  }

  set {
    name  = "vpcId"
    value = data.aws_vpc.default.id
  }
}