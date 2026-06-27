include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/vpc.hcl"
  merge_strategy = "deep"
}

# A smaller, single-NAT VPC is fine for shared tooling/services.
inputs = {
  cidr_block       = "10.10.0.0/16"
  az_count         = 3
  single_nat_gateway = true
}
