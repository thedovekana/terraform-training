provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA2VVEKHTWG37UNA3N"
  secret_key = "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"
}



#Création du s3 

resource "aws_s3_bucket" "terraform_backend_koni" {
  bucket = "terraform-backend-koni"
  acl    = "private"
  force_destroy = true
 
}
