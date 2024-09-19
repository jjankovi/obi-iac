resource "aws_instance" "example" {
  ami  = "ami-00060fac2f8c42d30"
  instance_type = "t3.micro"
}