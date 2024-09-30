module "eks_cluster" {
  source        = "./modules/eks"
  enviroment = var.environment
  project_name  = "obi"
  k8s_namespace = "obi-ns"
}