variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for worker nodes"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the cluster control plane and load balancers"
  type        = list(string)
}

variable "node_instance_types" {
  description = "Instance types for the managed node group"
  type        = list(string)
}

variable "node_desired_size" {
  description = "Desired node group size"
  type        = number
}

variable "node_min_size" {
  description = "Minimum node group size"
  type        = number
}

variable "node_max_size" {
  description = "Maximum node group size"
  type        = number
}

variable "node_disk_size" {
  description = "Root volume size in GiB for worker nodes"
  type        = number
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}
