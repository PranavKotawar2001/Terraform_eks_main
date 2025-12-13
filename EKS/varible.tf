# vpc CIDR block
variable "vpc_cidr_block" {}

# CIDR block for Subnet 1
variable "subnet1_cidr_block" {}


# CIDR block for Subnet 2
variable "subnet2_cidr_block" {}

# Availability Zones subnet 1
variable "availability_zone_1" {}

# Availability Zones subnet 2
variable "availability_zone_2" {}


# IAM Role name for EKS Cluster
variable "aws_iam_role_name" {}

# EKS Cluster name
variable "aws_eks_cluster_name" {}

# IAM Role name for EKS Node Group
variable "aws_iam_role_node_name" {}

# EKS Node Group name
variable "EKS_node_group_name" {}

# EKS Node Group desired, max, and min size
variable "desired_size" {}

variable "max_size" {}

variable "min_size" {}

# Instance types for EKS Node Group
variable "instance_types" {}

