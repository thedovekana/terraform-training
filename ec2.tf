provider "aws" {
  region     = "us-east-1"
  access_key = "your access key"
  secret_key = "your secret key"
}

resource "aws_instance" "myec2" {
  ami           = "ami-08e637cea2f053dfa"
  instance_type = "t2.micro"
  key_name      = "devops-koni"

  tags = {
    Name = "My EC2 instance"
  }
}
