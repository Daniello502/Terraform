# Defines the Virtual Network and Subnets

resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "main" {
  for_each             = toset(var.subnet_names) # Create multiple subnets based on the list of names
  name                 = each.value
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_prefixes[index(var.subnet_names, each.value)]] # Assign corresponding prefix
}

