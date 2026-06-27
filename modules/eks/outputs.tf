output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS API server."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded CA certificate for the cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the control plane."
  value       = aws_security_group.cluster.id
}

output "oidc_provider_arn" {
  description = "ARN of the IAM OIDC provider for IRSA (null when IRSA disabled)."
  value       = var.enable_irsa ? aws_iam_openid_connect_provider.this[0].arn : null
}

output "oidc_provider_url" {
  description = "OIDC issuer URL for the cluster."
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "node_role_arn" {
  description = "IAM role ARN shared by managed node groups."
  value       = aws_iam_role.node.arn
}
