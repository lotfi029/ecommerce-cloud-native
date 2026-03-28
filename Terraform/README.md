# Ecommerce Cloud-Native Infrastructure - Terraform Network Module

## Overview

This Terraform configuration sets up a complete AWS VPC network infrastructure for the ecommerce cloud-native application.

## Architecture

The infrastructure includes:

- **VPC**: "ecommerce" VPC with CIDR block `10.0.0.0/16`
- **Availability Zones**: 2 AZs (us-west-2a, us-west-2b)
- **Public Subnets**: 2 subnets for public-facing resources (10.0.1.0/24, 10.0.2.0/24)
- **Private Subnets**: 2 subnets for backend resources (10.0.10.0/24, 10.0.11.0/24)
- **Internet Gateway**: For public internet access
- **NAT Gateways**: 2 NAT gateways (one per AZ) for private subnet egress
- **Elastic IPs**: For NAT gateway static IPs
- **Route Tables**: 
  - 1 public route table (routes to IGW)
  - 2 private route tables (routes to respective NAT gateways)

## Directory Structure

```
Terraform/
├── Network/
│   ├── variables.tf          # Variable definitions
│   ├── vpc.tf                # VPC configuration
│   ├── subnets.tf            # Subnet configuration (public & private)
│   ├── igw.tf                # Internet Gateway configuration
│   ├── nat.tf                # NAT Gateway & Elastic IP configuration
│   ├── route_tables.tf       # Route table configuration and associations
│   ├── outputs.tf            # Output values
│   └── kustomization.yaml    # (Kubernetes related)
├── locals.tf                 # Local values and environment config
├── provider.tf               # AWS provider configuration
├── terraform.tfvars          # Default variable values
└── README.md                 # This file
```

## Variables

### Core Network Variables
- `vpc_name`: Name of the VPC (default: "ecommerce")
- `vpc_cidr`: CIDR block for VPC (default: "10.0.0.0/16")
- `availability_zones`: List of AZs (default: ["us-west-2a", "us-west-2b"])
- `public_subnet_cidrs`: CIDR blocks for public subnets (default: ["10.0.1.0/24", "10.0.2.0/24"])
- `private_subnet_cidrs`: CIDR blocks for private subnets (default: ["10.0.10.0/24", "10.0.11.0/24"])

### Feature Flags
- `enable_nat_gateway`: Enable NAT Gateway for private subnet egress (default: true)
- `enable_vpn_gateway`: Enable VPN Gateway (default: false)
- `enable_dns_hostnames`: Enable DNS hostnames in VPC (default: true)
- `enable_dns_support`: Enable DNS support in VPC (default: true)

### Metadata
- `environment`: Environment name (default: "staging")
- `aws_region`: AWS region (default: "us-west-2")
- `common_tags`: Tags applied to all resources

## Usage

### Prerequisites
```bash
# Install Terraform (version >= 1.0)
terraform --version

# Configure AWS credentials
aws configure
```

### Initialize Terraform
```bash
cd Terraform
terraform init
```

### Plan the Infrastructure
```bash
terraform plan
```

### Apply the Configuration
```bash
terraform apply
```

### Destroy the Infrastructure
```bash
terraform destroy
```

## Outputs

After applying the configuration, the following outputs are available:

- `vpc_id`: The ID of the created VPC
- `vpc_cidr`: The CIDR block of the VPC
- `public_subnet_ids`: IDs of public subnets
- `private_subnet_ids`: IDs of private subnets
- `internet_gateway_id`: ID of the Internet Gateway
- `nat_gateway_ids`: IDs of NAT Gateways
- `nat_gateway_ips`: Public static IPs of NAT Gateways
- `public_route_table_id`: ID of the public route table
- `private_route_table_ids`: IDs of private route tables
- `availability_zones`: List of AZs used

To view outputs after applying:
```bash
terraform output
```

## Network Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    VPC (10.0.0.0/16)                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           Internet Gateway (IGW)                    │   │
│  └────────────────────┬────────────────────────────────┘   │
│                       │                                      │
│  ┌────────────────────┴────────────────────────────────┐   │
│  │           Public Route Table                        │   │
│  │      (Route: 0.0.0.0/0 → IGW)                      │   │
│  └────────────┬───────────────────┬────────────────────┘   │
│               │                   │                         │
│     ┌─────────▼──────┐   ┌────────▼──────┐                │
│     │ Public Subnet 1│   │ Public Subnet2 │                │
│     │ (10.0.1.0/24)  │   │ (10.0.2.0/24)  │                │
│     │     AZ: us-west│   │    AZ: us-west │                │
│     │     -2a        │   │    -2b         │                │
│     │                │   │                │                │
│     │ NAT Gateway 1  │   │ NAT Gateway 2  │                │
│     │ EIP 1          │   │ EIP 2          │                │
│     └────────┬───────┘   └────────┬───────┘                │
│              │                    │                         │
│     ┌────────▼──────┬────────────────┬──────┐              │
│     │Private Route  │ Private Route  │      │              │
│     │Table 1        │ Table 2        │      │              │
│     │(Route:        │ (Route:        │      │              │
│     │0.0.0.0/0 →    │ 0.0.0.0/0 →    │      │              │
│     │NAT GW 1)      │ NAT GW 2)      │      │              │
│     └────────┬───────┴────────────────┴──────┘              │
│              │                                              │
│     ┌────────▼──────────────────┬──────────┐              │
│     │  Private Subnet 1          │ Private  │              │
│     │  (10.0.10.0/24)            │ Subnet 2 │              │
│     │  AZ: us-west-2a            │ (10.0.11│              │
│     │                            │ .0/24)   │              │
│     │  (EKS Nodes, Databases)    │ AZ:     │              │
│     │                            │us-west  │              │
│     │                            │-2b      │              │
│     │                            │         │              │
│     │                            │(EKS    │              │
│     │                            │Nodes)  │              │
│     └────────────────────────────┴─────────┘              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Security Considerations

1. **Public Subnets**: Host resources that need direct internet access (NAT Gateways, potentially ALB/NLB)
2. **Private Subnets**: Host backend resources (EKS nodes, databases, Redis, RabbitMQ, Elasticsearch)
3. **Outbound Access**: Private subnets can reach the internet via NAT Gateways
4. **DNS**: DNS support and hostnames are enabled for EKS service discovery
5. **High Availability**: Resources are distributed across 2 AZs for redundancy

## Customization

To customize the network setup:

1. **Change CIDR blocks**: Update `vpc_cidr`, `public_subnet_cidrs`, `private_subnet_cidrs` in `terraform.tfvars`
2. **Add more subnets**: Modify the subnet count or add new resources
3. **Change regions/AZs**: Update `aws_region` and `availability_zones` in `terraform.tfvars`
4. **Disable NAT Gateway**: Set `enable_nat_gateway = false` (not recommended for private subnets)

## Tags

All resources are tagged with:
- `Environment`: staging/production
- `ManagedBy`: Terraform
- `Project`: ecommerce

These tags help with resource organization and cost tracking.

## Common Issues

1. **Capacity Issues**: If Terraform fails due to capacity, switch to different AZs
2. **IP Address Exhaustion**: Increase CIDR block sizes if you need more IPs
3. **NAT Gateway Costs**: NAT Gateways have hourly charges + data transfer costs

## Next Steps

After network infrastructure is deployed:
1. Deploy the EKS cluster
2. Deploy networking policies (Kubernetes Network Policies)
3. Deploy ingress controller
4. Deploy services (catalog, user, search, etc.)

## Support

For issues or questions, refer to:
- AWS VPC documentation: https://docs.aws.amazon.com/vpc/
- Terraform AWS provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
