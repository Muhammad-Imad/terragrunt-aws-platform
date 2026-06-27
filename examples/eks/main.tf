# Example: a minimal EKS cluster on top of the VPC module.
# Run with plain Terraform (no Terragrunt) for quick local validation.

provider "aws" {
  region = "eu-central-1"
}

module "vpc" {
  source = "../../modules/vpc"

  name               = "example-vpc"
  cidr_block         = "10.42.0.0/16"
  az_count           = 2
  single_nat_gateway = true
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = "example-eks"
  kubernetes_version = "1.30"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids

  node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
