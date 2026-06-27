include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/eks.hcl"
  merge_strategy = "deep"
}

# Modest cluster for internal platform tooling (CI runners, ArgoCD, etc.).
inputs = {
  kubernetes_version = "1.30"

  node_groups = {
    tooling = {
      instance_types = ["t3.large"]
      desired_size   = 2
      min_size       = 1
      max_size       = 4
      capacity_type  = "ON_DEMAND"
    }
  }
}
