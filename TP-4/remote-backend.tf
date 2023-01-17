provider "aws" {
  region     = "us-east-1"
  access_key = "your acces key"
  secret_key = "your secret key"
}

terraform {
  backend "s3" {
    bucket     = "terraform-backend-koni"
    key        = "koni.tfstate"
    region     = "us-east-1"
    access_key = "your acces key"
    secret_key = "your secret key"
  }
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

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myec2" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instancetype
  key_name               = "devops-koni"
  tags                   = var.aws_common_tags
  security_groups = ["${aws_security_group.koni-sg.name}"]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./devops-koni.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }

}


resource "aws_eip" "lb" {
  instance = aws_instance.myec2.id
  vpc      = true
  provisioner "local-exec" {
    command = "echo PUBLIC IP: ${aws_eip.lb.public_ip} ; ID: ${aws_instance.myec2.id} ; AZ: ${aws_instance.myec2.availability_zone}; >> infos_ec2.txt"
  }
}

