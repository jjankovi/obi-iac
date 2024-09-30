resource "aws_eks_addon" "coredns" {
  depends_on = [
    aws_eks_fargate_profile.fargate_profile,
    kubernetes_config_map.cloudwatch_config_map
  ]
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "coredns"
  resolve_conflicts_on_create = "OVERWRITE"
  configuration_values = jsonencode({
    replicaCount = 1
    computeType = "Fargate"
    resources = {
      limits = {
        cpu    = "100m"
        memory = "150Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "150Mi"
      }
    }
  })
}
