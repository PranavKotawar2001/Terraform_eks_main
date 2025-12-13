provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}



module "vpc" {
#   Path to the VPC module
  source = "/EKS"

#   vpc_cidr_block 
  vpc_cidr_block = var.vpc_cidr_block

#   subnet CIDR blocks
  subnet1_cidr_block = var.subnet1_cidr_block
  subnet2_cidr_block = var.subnet2_cidr_block

#   availability zones
  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
#   IAM Role and EKS Cluster details
  aws_iam_role_name = var.aws_iam_role_name

#   EKS Cluster name
  aws_eks_cluster_name = var.aws_eks_cluster_name

#   IAM Role and EKS Node Group details
  aws_iam_role_node_name = var.aws_iam_role_node_name
  EKS_node_group_name = var.EKS_node_group_name

#   EKS Node Group scaling 
  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size

#   EKS Node Group instance types
  instance_types = var.instance_types
 
}