# _envcommon/s3-cloudfront.hcl
#
# Shared definition for a static-site / asset delivery stack:
# private S3 origin fronted by CloudFront with Origin Access Control (OAC).

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_name = local.account_vars.locals.account_name
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}//modules/s3-cloudfront"
}

inputs = {
  bucket_name = "${local.account_name}-assets"

  # ACM for CloudFront must live in us-east-1; the module provisions it there
  # via an aliased provider. Route53 wiring is optional per environment.
  enable_custom_domain = false
  price_class          = "PriceClass_100"
  default_root_object  = "index.html"

  tags = {
    Component = "s3-cloudfront"
  }
}
