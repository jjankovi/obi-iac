resource "aws_instance" "example" {
  ami           = "ami-00060fac2f8c42d30"
  instance_type = "t3.micro"
  monitoring = true
  ebs_optimized = true
  metadata_options {
    http_endpoint = "disabled"
  }
  root_block_device {
    encrypted     = true
  }
  tags = {
    Environment  = var.environment
  }
}