# provider
variable "region" {
  default = "ap-south-1"
}

# # access key
# variable "access_key" {
#   default = ""
# }

# # secret key
# variable "secret_key" {
#   default = ""
# }

# Availability Zones subnet 1
variable "availability_zone_1" {
    default = "ap-south-1a"
}

# Availability Zones subnet 2
variable "availability_zone_2" {
    default = "ap-south-1b"
}


# EKS Cluster name
variable "aws_eks_cluster_name" {
    default = "my-eks-cluster"
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