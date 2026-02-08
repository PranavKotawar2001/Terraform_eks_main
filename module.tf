provider "aws" {
  region = var.region
  # access_key = var.access_key
  # secret_key = var.secret_key
}



module "vpc" {
#   Path to the VPC module
  source = "/EKS"

#   availability zones
  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2

#   EKS Node Group scaling 
  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size

#   EKS Node Group instance types
  instance_types = var.instance_types
 
}