variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "westeurope"
}

variable "subscription_id" {
  description = "The Azure Subscription ID to use."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "hybridcloud-rg"
}

variable "vnet_address_space" {
  description = "Address space for the Azure VNet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "onprem_address_space" {
  description = "On-premises address space"
  type        = string
  default     = "192.168.0.0/16"
}

variable "onprem_public_ip" {
  description = "On-premises VPN device public IP"
  type        = string
}

variable "vpn_shared_key" {
  description = "Shared key for the VPN connection (use a secret)"
  type        = string
  sensitive   = true
}
