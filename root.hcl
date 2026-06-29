# root.hcl
#
# Root Terragrunt configuration. Every leaf unit `include`s this file to inherit
# remote state, provider generation, and common inputs. This is the single place
# where backend and provider boilerplate lives — keeping the whole platform DRY.

locals {
  # Parse the folder hierarchy: accounts/<account>/<region>/<component>
  # to derive context that every unit needs without repeating it.
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.account_id
  aws_region   = local.region_vars.locals.aws_region

  org    = "acme"
  domain = "example.com"

  # Tags applied to every taggable resource across the platform.
  common_tags = {
    ManagedBy  = "terragrunt"
    Org        = local.org
    Account    = local.account_name
    Region     = local.aws_region
    Repository = "terragrunt-aws-platform"
  }
}

# ---------------------------------------------------------------------------
# Remote state — S3 bucket with native locking + a DynamoDB lock table.
# Bucket/table names are placeholders; swap for your own provisioned backend.
# ---------------------------------------------------------------------------
remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = "${local.org}-tf-state-${local.account_id}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "${local.org}-tf-locks"

    # Server-side encryption with a customer-managed KMS key is recommended.
    # Replace with your KMS key ARN; alias placeholder shown here.
    # kms_key_id = "arn:aws:kms:${local.aws_region}:${local.account_id}:alias/${local.org}-tf-state"
  }
}

# ---------------------------------------------------------------------------
# Provider generation — assume an OrganizationAccountAccessRole-style role in
# the target account so the same pipeline credentials manage all accounts.
# ---------------------------------------------------------------------------
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "aws" {
      region = "${local.aws_region}"

      assume_role {
        role_arn     = "arn:aws:iam::${local.account_id}:role/TerragruntDeployRole"
        session_name = "terragrunt-${local.account_name}"
      }

      default_tags {
        tags = ${jsonencode(local.common_tags)}
      }
    }
  EOF
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_version = ">= 1.5"

      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = ">= 5.0"
        }
      }
    }
  EOF
}

# Inputs merged into every unit. Leaf units and _envcommon add to these.
inputs = {
  org         = local.org
  domain      = local.domain
  account_id  = local.account_id
  aws_region  = local.aws_region
  common_tags = local.common_tags
}
