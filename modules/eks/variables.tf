variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes control plane version."
  type        = string
  default     = "1.30"
}

variable "vpc_id" {
  description = "VPC the cluster is deployed into."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the control plane ENIs and node groups."
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Whether the EKS API server has a public endpoint."
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "CIDRs allowed to reach the public API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_irsa" {
  description = "Create an IAM OIDC provider for IRSA (IAM Roles for Service Accounts)."
  type        = bool
  default     = true
}

variable "enabled_cluster_log_types" {
  description = "Control plane log types to ship to CloudWatch."
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "cluster_addons" {
  description = "Managed EKS add-ons to install."
  type        = list(string)
  default     = ["coredns", "kube-proxy", "vpc-cni"]
}

variable "node_groups" {
  description = "Map of managed node groups keyed by name."
  type = map(object({
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    capacity_type  = optional(string, "ON_DEMAND")
    disk_size      = optional(number, 50)
    labels         = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "Additional tags merged onto all resources."
  type        = map(string)
  default     = {}
}
