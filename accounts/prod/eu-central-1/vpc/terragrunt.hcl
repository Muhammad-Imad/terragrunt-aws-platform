include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/vpc.hcl"
  merge_strategy = "deep"
}

# Production: one NAT gateway per AZ for resilience, no overlapping CIDR.
inputs = {
  cidr_block         = "10.20.0.0/16"
  az_count           = 3
  single_nat_gateway = false
}
