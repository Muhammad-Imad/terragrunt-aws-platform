# Example: private S3 origin behind CloudFront with OAC, no custom domain.

provider "aws" {
  region = "eu-central-1"
}

# CloudFront ACM must live in us-east-1; the module expects this aliased
# provider even when custom domains are disabled.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "site" {
  source = "../../modules/s3-cloudfront"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  bucket_name          = "example-acme-assets-111111111111"
  enable_custom_domain = false
  price_class          = "PriceClass_100"
}

output "cdn_domain" {
  value = module.site.distribution_domain_name
}
