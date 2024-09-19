# EKS Cluster Role
resource "aws_iam_role" "eks_cluster_role" {
  count = var.delete ? 0 : 1
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

resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  count = var.delete ? 0 : 1
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# EKS Fargate Role
resource "aws_iam_role" "eks_fargate_role" {
  count = var.delete ? 0 : 1
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

resource "aws_iam_role_policy_attachment" "eks_fargate_policy_attachment" {
  count = var.delete ? 0 : 1
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_role.name
}

# TODO JJA access entry
#resource "aws_eks_access_entry" "example" {
#  cluster_name      = aws_eks_cluster.eks_cluster.name
#  principal_arn     = "arn:aws:iam::396608792866:user/WorkloadAdministrator"
#  kubernetes_groups = ["group-1", "group-2"]
#  type              = "STANDARD"
#}
