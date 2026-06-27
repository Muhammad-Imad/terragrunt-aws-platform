include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/eks.hcl"
  merge_strategy = "deep"
}

# Production cluster: locked-down API endpoint, mixed node groups.
inputs = {
  kubernetes_version           = "1.30"
  endpoint_public_access       = true
  endpoint_public_access_cidrs = ["203.0.113.0/24"] # office / VPN egress only

  node_groups = {
    general = {
      instance_types = ["m6i.large"]
      desired_size   = 3
      min_size       = 3
      max_size       = 9
      capacity_type  = "ON_DEMAND"
    }
    spot = {
      instance_types = ["m6i.large", "m6a.large", "m5.large"]
      desired_size   = 2
      min_size       = 0
      max_size       = 12
      capacity_type  = "SPOT"
    }
  }
}
