resource "aws_eks_fargate_profile" "fargate_profile" {
  depends_on = [
    kubernetes_namespace.eks_namespace
  ]
  cluster_name = aws_eks_cluster.eks_cluster.name
  fargate_profile_name = "${var.project_name}-fargate-profile"

  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn

  subnet_ids = local.private_subnet_ids

  selector {
    namespace = kubernetes_namespace.eks_namespace.id
  }

  selector {
    namespace = "kube-system"
  }
}

resource "aws_iam_role" "eks_fargate_role" {
  name = "${var.project_name}-eks-fargate-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

data "aws_iam_policy_document" "fargate_cloudwatch_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "fargate_cloudwatch_policy" {
  policy      = data.aws_iam_policy_document.fargate_cloudwatch_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "fargate_cloudwatch_policy_attachment" {
  role       = aws_iam_role.eks_fargate_role.name
  policy_arn = aws_iam_policy.fargate_cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "eks_fargate_policy_attachment" {
  role       = aws_iam_role.eks_fargate_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}