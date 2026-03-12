terraform {
  backend "s3" {
    bucket         = "s3-state-bucket-terraform-backend"
    key            = "terraform.tfstate"   
    region         = "us-east-1"                   
    dynamodb_table = "dynamodb-lock-table"        
    encrypt        = true                          
  }
}