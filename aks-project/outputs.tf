# Output variables from the root module

output "aks_cluster_name" {
  description = "The name of the AKS cluster."
  value       = module.aks.aks_cluster_name
}

output "resource_group_name" {
  description = "The name of the resource group where AKS is deployed."
  value       = azurerm_resource_group.main.name
}

output "kube_config" {
  description = "The Kubernetes configuration file for the AKS cluster."
  value       = module.aks.kube_config_raw
  sensitive   = true # Mark as sensitive as it contains credentials
}

output "argocd_server_public_ip" {
  description = "The public IP address of the Argo CD server LoadBalancer."
  value       = helm_release.argocd.status[0].load_balancer.ingress[0].ip
}

output "argocd_initial_admin_password" {
  description = "The initial password for the Argo CD admin user."
  value       = var.argocd_initial_admin_password
  sensitive   = true # Mark as sensitive
}

