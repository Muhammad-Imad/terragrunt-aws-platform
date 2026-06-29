# _envcommon/eks.hcl
#
# Shared definition for the EKS component. Notice the `dependency "vpc"` block:
# Terragrunt resolves the VPC unit's outputs and feeds them in, which both wires
# the modules together AND establishes the apply ordering (vpc before eks) used
# by `terragrunt run-all`.

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_name = local.account_vars.locals.account_name
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}//modules/eks"
}

# Depend on the VPC unit that lives as a sibling directory.
dependency "vpc" {
  config_path = "../vpc"

  # Mock outputs let `validate`/`plan` run before the VPC actually exists
  # (e.g. in CI on a fresh checkout).
  mock_outputs = {
    vpc_id             = "vpc-00000000000000000"
    private_subnet_ids = ["subnet-00000000000000001", "subnet-00000000000000002", "subnet-00000000000000003"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  cluster_name = "${local.account_name}-eks"

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  # Defaults; leaf units override Kubernetes version and node group sizing.
  kubernetes_version           = "1.30"
  endpoint_public_access       = true
  endpoint_public_access_cidrs = ["0.0.0.0/0"] # tighten per environment
  enable_irsa                  = true
  enabled_cluster_log_types    = ["api", "audit", "authenticator"]
  cluster_addons               = ["coredns", "kube-proxy", "vpc-cni"]

  tags = {
    Component = "eks"
  }
}
