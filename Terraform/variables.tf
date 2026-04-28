variable "environment" {
  default = "staging"
}

variable "aws_region" {
  default = "us-west-2"
}

variable "cluster_name" {
  default = "ecommerce-eks"
}

variable "cluster_version" {
  default = "1.30"
}

variable "availability_zones" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "vpc_name" {
  default = "ecommerce"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "node_instance_types" {
  default = ["t3.medium"]
}

variable "node_desired_size" {
  default = 2
}

variable "node_min_size" {
  default = 1
}

variable "node_max_size" {
  default = 5
}

variable "node_disk_size" {
  default = 20
}
