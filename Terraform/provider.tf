
provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Environment = local.env
      ManagedBy   = "Terraform"
      Project     = "ecommerce"
    }
  }
}
