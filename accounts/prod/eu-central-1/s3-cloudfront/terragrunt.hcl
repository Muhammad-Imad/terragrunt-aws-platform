include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/s3-cloudfront.hcl"
  merge_strategy = "deep"
}

# Production public site served from a custom domain with managed TLS.
inputs = {
  bucket_name          = "prod-acme-web-assets"
  enable_custom_domain = true
  domain_aliases       = ["cdn.example.com"]
  hosted_zone_name     = "example.com"
  price_class          = "PriceClass_200"
}
