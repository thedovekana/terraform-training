provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA2VVEKHTWG7ASKMML"
  secret_key = "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"
}

data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

}

resource "aws_security_group" "koni-sg" {
  name        = "koni-sg"
  description = "koni security group to allow http & https traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_eip" "lb" {
  instance = aws_instance.myec2.id
  vpc      = true
}

resource "aws_instance" "myec2" {
  ami             = data.aws_ami.app_ami.id
  instance_type   = var.instancetype
  key_name        = "devops-koni"
  tags            = var.aws_common_tags
  security_groups = ["${aws_security_group.koni-sg.name}"]

}

