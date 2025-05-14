# Input variables for the AKS module

variable "resource_group_name" {
  description = "The name of the resource group the AKS cluster belongs to."
  type        = string
}

variable "location" {
  description = "The Azure region for the AKS cluster."
  type        = string
}

variable "aks_cluster_name" {
    description = "The name of the cluster
    type = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster."
  type        = string
}

variable "node_count" {
    description = "Number of nodes"
    type = number
}

variable "aks_subnet_id" {
  description = "The ID of the subnet where AKS nodes will be deployed."
  type        = string
}
