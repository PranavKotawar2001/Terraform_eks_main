# Amazon EKS Cluster using Terraform (Step-by-Step Guide)

## 📌 Prerequisites

Before starting, make sure you have:

* An **AWS account**
* **AWS CLI** installed and configured (`aws configure`)
* **Terraform** installed (v1.x recommended)
* Basic knowledge of:

  * AWS VPC
  * IAM
  * Kubernetes (optional but helpful)

---


---

## Step 1: Create a VPC for EKS (We can use default VPC also)

### Why?

EKS must run inside a **VPC**. A custom VPC gives better control over networking and security.

### What this code does:

* Creates a VPC with CIDR `10.0.0.0/16`
* Enables DNS support and DNS hostnames (mandatory for EKS)

```hcl
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}
```

---

## Step 2: Create Private Subnets

### Why private subnets?

* EKS worker nodes are more secure in **private subnets**
* Nodes do not get public IPs
* Traffic is controlled via NAT (not included here, but recommended)

### What this code does:

* Creates **two private subnets**
* Each subnet is in a different Availability Zone (high availability)

```hcl
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone_1

  tags = {
    Name = "eks-private-1"
  }
}
```

```hcl
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone_2

  tags = {
    Name = "eks-private-2"
  }
}
```

---

## Step 3: Create IAM Role for EKS Cluster

### Why?

The **EKS control plane** needs permission to:

* Manage networking
* Communicate with AWS services

### What this code does:

* Creates an IAM role assumed by `eks.amazonaws.com`
* Attaches `AmazonEKSClusterPolicy`

```hcl
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}
```

```hcl
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
```

---

## Step 4: Create the EKS Cluster

### What this does:

* Creates the **EKS control plane**
* Associates it with:

  * IAM role
  * Private subnets

```hcl
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.aws_eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}
```

📌 **Note:** This creates only the control plane, not worker nodes.

---

## Step 5: Create IAM Role for Worker Nodes

### Why?

Worker nodes (EC2 instances) need permissions to:

* Join the EKS cluster
* Pull images from ECR
* Manage networking (CNI)

### IAM Role Creation

```hcl
resource "aws_iam_role" "node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}
```

### Attach Required Policies

```hcl
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
```

```hcl
resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
```

```hcl
resource "aws_iam_role_policy_attachment" "registry_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
```

---

## Step 6: Create EKS Managed Node Group

### Why Managed Node Group?

* AWS manages EC2 lifecycle
* Easier upgrades
* Auto scaling support

### What this code does:

* Launches EC2 worker nodes
* Attaches them to the EKS cluster
* Enables auto scaling

```hcl
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.node_role.arn

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.registry_policy
  ]
}
```

---

## Step 7: Terraform Execution Flow

Run the following commands:

```bash
terraform init
```

* Downloads AWS provider
* Initializes Terraform backend

```bash
terraform plan
```

* Shows execution plan
* Verifies configuration

```bash
terraform apply
```

* Creates VPC
* Creates subnets
* Creates IAM roles
* Creates EKS cluster
* Creates node group

---


---

## 🚀 Next Recommended Enhancements

* Add **Internet Gateway & NAT Gateway**
* Enable **Cluster Logging**
* Add **Security Groups** explicitly
* Enable **IRSA (IAM Roles for Service Accounts)**
* Add **Ingress Controller (ALB)**

---
