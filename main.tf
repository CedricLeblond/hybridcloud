resource "azurerm_resource_group" "lz_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "lz_vnet" {
  name                = "lz-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.lz_rg.location
  resource_group_name = azurerm_resource_group.lz_rg.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "lz_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.lz_rg.name
  virtual_network_name = azurerm_virtual_network.lz_vnet.name
  address_prefixes     = [var.subnet_address_prefix]
  # Subnets do not support tags
}

resource "azurerm_public_ip" "vpn_gw_ip" {
  name                = "vpn-gw-ip"
  location            = azurerm_resource_group.lz_rg.location
  resource_group_name = azurerm_resource_group.lz_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_virtual_network_gateway" "vpn_gw" {
  name                = "lz-vpn-gw"
  location            = azurerm_resource_group.lz_rg.location
  resource_group_name = azurerm_resource_group.lz_rg.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw1"
  tags                = local.common_tags

  ip_configuration {
    name                 = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.vpn_gw_ip.id
    subnet_id            = azurerm_subnet.lz_subnet.id
  }
}

resource "azurerm_local_network_gateway" "onprem" {
  name                = "onprem-lng"
  location            = azurerm_resource_group.lz_rg.location
  resource_group_name = azurerm_resource_group.lz_rg.name
  gateway_address     = var.onprem_public_ip
  address_space       = [var.onprem_address_space]
  tags                = local.common_tags
}

resource "azurerm_virtual_network_gateway_connection" "vpn_conn" {
  name                       = "lz-to-onprem-vpn"
  location                   = azurerm_resource_group.lz_rg.location
  resource_group_name        = azurerm_resource_group.lz_rg.name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_gw.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem.id
  connection_protocol        = "IKEv2"
  shared_key                 = var.vpn_shared_key
  tags                       = local.common_tags
}

# Network Security Group
resource "azurerm_network_security_group" "lz_nsg" {
  name                = "lz-nsg"
  location            = azurerm_resource_group.lz_rg.location
  resource_group_name = azurerm_resource_group.lz_rg.name
  tags                = local.common_tags

  security_rule {
    name                       = "Allow-VPN-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.onprem_address_space
    destination_address_prefix = var.vnet_address_space
  }
}

# Remove NSG association for GatewaySubnet (forbidden by Azure)
# resource "azurerm_subnet_network_security_group_association" "lz_subnet_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.lz_subnet.id
#   network_security_group_id = azurerm_network_security_group.lz_nsg.id
# }

# Diagnostic settings for logging (NSG logs to Log Analytics)
resource "azurerm_log_analytics_workspace" "lz_law" {
  name                = "lz-law"
  location            = azurerm_resource_group.lz_rg.location
  resource_group_name = azurerm_resource_group.lz_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}

resource "azurerm_monitor_diagnostic_setting" "lz_nsg_diag" {
  name                       = "lz-nsg-diag"
  target_resource_id         = azurerm_network_security_group.lz_nsg.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lz_law.id

  enabled_log  {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}
