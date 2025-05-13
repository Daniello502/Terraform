# Output variables from the network module

output "aks_subnet_id" {
  description = "The ID of the subnet designated for AKS."
  value       = azurerm_subnet.main["aks-subnet"].id 
}

output "other_subnet_id" {
  description = "The ID of the other subnet."
  value       = azurerm_subnet.main["other-subnet"].id 
}



