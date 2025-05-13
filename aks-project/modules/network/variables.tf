# Input variables for the network module

variable "resource_group_name" {
  description = "The name of the resource group the network resources belong to."
  type        = string
}

variable "location" {
  description = "The Azure region for the network resources."
  type        = string
}

variable "location" {
  description = "The Azure region for the network resources."
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "A list of address prefixes for the subnets."
  type        = list(string)
}

variable "subnet_names" {
  description = "A list of names for the subnets."
  type        = list(string)
}

