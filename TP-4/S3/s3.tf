provider "aws" {
  region     = "us-east-1"
  access_key = "XXXXXX"
  secret_key = "XXXXX"
}



#Création du s3 

resource "aws_s3_bucket" "terraform_backend_koni" {
  bucket = "terraform-backend-koni"
  acl    = "private"
  force_destroy = true
 
}
