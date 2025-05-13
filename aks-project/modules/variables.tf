# Input variables for the root module

variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
  default     = "aks-demo-rg"
}

variable "location" {
  description = "The Azure region to deploy resources in."
  type        = string
  default     = "East US" # Change to your preferred region
}
variable "vnet_name" {
    description = "name of the vnet"
    type = string
    default = "aks-vnet"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  description = "A list of address prefixes for the subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"] # Subnet for AKS, Subnet for other resources
}

variable "subnet_names" {
  description = "A list of names for the subnets."
  type        = list(string)
  default     = ["aks-subnet", "other-subnet"]
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
  default     = "my-aks-cluster"
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster."
  type        = string
  default     = "1.27" # Use a supported version for your region, check Azure docs
}

variable "agent_pool_node_count" {
  description = "The number of nodes in the default agent pool."
  type        = number
  default     = 2
}

# Variables for Argo CD
variable "argocd_chart_version" {
  description = "The version of the Argo CD Helm chart to deploy."
  type        = string
  default     = "5.x.x" # **IMPORTANT: Replace with a recent, stable chart version from Artifact Hub**
}

variable "argocd_initial_admin_password" {
  description = "The initial password for the Argo CD admin user.
  type        = string
  default     = "Pa$$word321" 
  sensitive   = true # Mark as sensitive
}
