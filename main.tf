resource "aws_instance" "example" {
  ami           = "ami-00060fac2f8c42d30"
  instance_type = "t3.micro"
  tags = {
    Environment  = var.environment
  }
}

#module eks_cluster {
#  source = "./modules/eks"
#  project_name = "obi"
#  enviroment = var.enviroment
#  k8s_namespace = "obi-ns"
#  k8s_app_port = "80"
#  k8s_cpu = "256m"
#  k8s_cpu_limit = "512m"
#  k8s_memory = "512Mi"
#  k8s_memory_limit = "1Gi"
#}