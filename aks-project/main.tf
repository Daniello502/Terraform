# Configure providers
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.0" # Use the latest major version recommended
    }
    # Add Kubernetes provider
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0" # Pin to a stable major version
    }
    # Add Helm provider
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.0" # Pin to a stable major version
    }
  }
}

#it configues thru az cli
provider "azurerm" {
  features {}
}

# Configuration depends on AKS module creation and outputs
provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

# Configure the Helm Provider to connect to the AKS cluster
# This configuration depends on the AKS cluster being created first
provider "helm" {
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

# Create a Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Call the Network Module
module "network" {
  source = "./modules/network" # Local path to the network module

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  vnet_name           = var.vnet_name
  address_space       = var.vnet_address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names

  depends_on = [azurerm_resource_group.main] # Ensure resource group is created first
}

# Call the AKS Module
module "aks" {
  source = "./modules/aks" # Local path to the aks module

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  aks_cluster_name    = var.aks_cluster_name
  kubernetes_version  = var.kubernetes_version
  node_count          = var.agent_pool_node_count
  aks_subnet_id       = module.network.aks_subnet_id # Get the AKS subnet ID from the network module output

  depends_on = [
    azurerm_resource_group.main,
    module.network
  ]
}

# Deploy Argo CD using the Helm Provider
resource "helm_release" "argocd" {
  name             = "argocd" # Name of the Helm release
  repository       = "https://argoproj.github.io/argo-helm" # Official Argo CD Helm chart repository
  chart            = "argo-cd"
  version          = var.argocd_chart_version # Use a variable for the chart version
  namespace        = "argocd" # Deploy into the 'argocd' namespace (will be created)
  create_namespace = true     # Automatically create the namespace

  # Example values to customize the Argo CD installation
  values = [<<EOT
server:
  service:
    type: LoadBalancer # Expose Argo CD server via a LoadBalancer (get a public IP)
    ports:
      - port: 80
        targetPort: 8080
        protocol: TCP
        name: http
      - port: 443
        targetPort: 8080 # Argo CD listens on 8080 by default
        protocol: TCP
        name: https
        
# Set the initial admin password (IMPORTANT: Change this to a strong password or use a secret)
# This is for demonstration purposes. In production, use a proper secrets management solution.
initialAdminPassword: "${var.argocd_initial_admin_password}"


  # Ensure Argo CD is deployed after the AKS cluster is available and providers are configured
  depends_on = [
    module.aks
  ]
}