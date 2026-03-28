# Ecommerce Cloud-Native

This repository contains the infrastructure and deployment files for an e-commerce platform built with Terraform and Kubernetes.

## Overview

- `Terraform/` provisions the AWS network layer with a VPC, public and private subnets, internet gateway, NAT, and route tables.
- `CD/` contains Kubernetes manifests and Kustomize bases for the application stack.
- Components included in this repo: Catalog, User, PostgreSQL, Elasticsearch, Kibana, and Ingress.
- `CD/redis` and `CD/rmq` currently exist as placeholders.

## Project Structure

- `Terraform/` Terraform root module and AWS network module
- `CD/catalog/` Catalog service manifests
- `CD/user/` User service manifests
- `CD/postgres/` PostgreSQL manifests
- `CD/search/` Elasticsearch and Kibana manifests
- `CD/ingress/` Ingress manifests

## Requirements

- Terraform 1.0+
- AWS credentials configured
- Kubernetes cluster
- `kubectl` with Kustomize support

## Quick Start

```bash
cd Terraform
terraform init
terraform apply

kubectl apply -k CD
```

## Future Work

- Add Terraform support for provisioning an Amazon EKS cluster
- Complete Redis and RabbitMQ deployment manifests
- Improve production readiness with monitoring, security, and CI/CD automation

## Notes

- Default Terraform values target AWS `us-west-2`.
- The Terraform code in this repo currently creates the networking layer only.
- Application source code is not included in this repository.
