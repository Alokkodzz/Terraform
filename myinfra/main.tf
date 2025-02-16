terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.87.0"
    }
  }
}


provider "aws"{
    region = "us-east-1"
}


module "vpc" {
  source = "./modules/VPC"
  ami = local.ami
  instance_type = local.instance_type
  subnet_id = local.subnet_id
  availability_zone = local.VPC_availability_zone
}

module "eks" {
  source = "./modules/EKS"
  subnet_ids = module.vpc.Private_subnet
  node_groups = var.node_groups
  cluster_version = var.cluster_version
}