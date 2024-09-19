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


#resource "aws_instance" "ec2_instance" {
#  ami           = "ami-00060fac2f8c42d30"
#  instance_type = "t3.micro"
#  monitoring = true
#  ebs_optimized = true
#  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
#  metadata_options {
#    http_endpoint = "disabled"
#  }
#  root_block_device {
#    encrypted     = true
#  }
#  tags = {
#    Environment  = var.environment
#  }
#}
#
#resource "aws_iam_role" "ec2_role" {
#  name = "ec2-role"
#
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [{
#      Effect = "Allow"
#      Principal = {
#        Service = "ec2.amazonaws.com"
#      }
#      Action = "sts:AssumeRole"
#    }]
#  })
#}
#
#resource "aws_iam_instance_profile" "ec2_instance_profile" {
#  name = "ec2-instance-profile"
#  role = aws_iam_role.ec2_role.name
#}