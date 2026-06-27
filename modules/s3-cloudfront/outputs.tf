output "bucket_name" {
  description = "Name of the origin bucket."
  value       = aws_s3_bucket.origin.bucket
}

output "bucket_arn" {
  description = "ARN of the origin bucket."
  value       = aws_s3_bucket.origin.arn
}

output "distribution_id" {
  description = "CloudFront distribution ID."
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_domain_name" {
  description = "Default CloudFront domain name (e.g. dxxxx.cloudfront.net)."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.arn
}

output "certificate_arn" {
  description = "ARN of the ACM certificate (null when custom domain disabled)."
  value       = local.custom_domain ? aws_acm_certificate.this[0].arn : null
}
