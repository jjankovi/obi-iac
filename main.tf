module eks_cluster {
  source = "./modules/eks"
  project_name = "obi"
  enviroment = var.environment
  k8s_namespace = "obi-ns"
  k8s_app_port = "80"
  k8s_cpu = "256m"
  k8s_cpu_limit = "512m"
  k8s_memory = "512Mi"
  k8s_memory_limit = "1Gi"
}