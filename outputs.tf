output "vpn_gateway_public_ip" {
  value = azurerm_public_ip.vpn_gw_ip.ip_address
}

output "vnet_id" {
  value = azurerm_virtual_network.lz_vnet.id
}
