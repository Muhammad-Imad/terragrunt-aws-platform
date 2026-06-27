# _envcommon/vpc.hcl
#
# Shared definition for the VPC component. Leaf units `include` this with
# `merge_strategy = "deep"` and override only what differs per environment
# (CIDR, AZ count, NAT strategy). This is the core DRY mechanism: one place
# describes "what a VPC looks like here", many places instantiate it.

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_name = local.account_vars.locals.account_name
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}//modules/vpc"
}

inputs = {
  name = "${local.account_name}-vpc"

  # Sensible defaults; leaf units narrow these to their environment.
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_flow_logs     = true

  tags = {
    Component = "vpc"
  }
}
