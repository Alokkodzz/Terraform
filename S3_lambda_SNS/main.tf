provider "aws" {
    region = "us-east-1"
  
}

module "s3_project" {
  source = "./s3project"
}