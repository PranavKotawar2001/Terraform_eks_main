# provider
variable "region" {
  default = "ap-south-1"
}

# access key
variable "access_key" {
  default = ""
}

# secret key
variable "secret_key" {
  default = ""
}

# CIDR block for VPC
variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

# CIDR block for Subnet 1
variable "subnet1_cidr_block" {
    default = "10.0.1.0/24"
}

# CIDR block for Subnet 2
variable "subnet2_cidr_block" {
    default = "10.0.2.0/24"
}

# Availability Zones subnet 1
variable "availability_zone_1" {
    default = "ap-south-1a"
}

# Availability Zones subnet 2
variable "availability_zone_2" {
    default = "ap-south-1b"
}

# IAM Role name for EKS Cluster
variable "aws_iam_role_name" {
    default = "eks-cluster-role"
}

# EKS Cluster name
variable "aws_eks_cluster_name" {
    default = "my-eks-cluster"
}

# IAM Role name for EKS Node Group
variable "aws_iam_role_node_name" {
    default = "eks-node-role"
}

# EKS Node Group name
variable "EKS_node_group_name" {
    default = "eks-node-group"
}

# EKS Node Group desired, max, and min size
variable "desired_size" {
    default = 2
}

variable "max_size" {
    default = 3
}

variable "min_size" {
    default = 1
}

variable "instance_types" {
  default = ["t3.medium"]
}