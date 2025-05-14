# Output variables from the AKS module

output "aks_cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.name
}

output "kube_config" {
  description = "The Kubernetes configuration file for the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true # Mark as sensitive as it contains credentials
}

output "aks_principal_id" {
  description = "The Principal ID of the System Assigned Managed Identity of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

# Add outputs for Kubernetes provider configuration
output "host" {
  description = "The hostname (in form of URI) of the Kubernetes API."
  value       = azurerm_kubernetes_cluster.main.kube_config[0].host
}

output "client_certificate" {
  description = "PEM-encoded client certificate for TLS authentication."
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive   = true
}

output "client_key" {
  description = "PEM-encoded client certificate key for TLS authentication."
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "PEM-encoded root certificates bundle for TLS authentication."
  value       = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive   = true
}
