variable "bucket_name" {
  description = "Name of the private S3 origin bucket."
  type        = string
}

variable "default_root_object" {
  description = "Object returned for requests to the distribution root."
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "price_class must be one of PriceClass_All, PriceClass_200, PriceClass_100."
  }
}

variable "enable_custom_domain" {
  description = "Provision ACM (us-east-1) + Route53 records and attach aliases to the distribution."
  type        = bool
  default     = false
}

variable "domain_aliases" {
  description = "CNAMEs / aliases served by the distribution (requires enable_custom_domain)."
  type        = list(string)
  default     = []
}

variable "hosted_zone_name" {
  description = "Route53 public hosted zone name for ACM validation and alias records."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags merged onto all resources."
  type        = map(string)
  default     = {}
}
