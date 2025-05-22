# Development environment variable values for Terraform
location = "westeurope"
resource_group_name = "hybridcloud-rg"
vnet_address_space = "10.1.0.0/16"
subnet_address_prefix = "10.1.1.0/24"
onprem_address_space = "192.168.0.0/16"
onprem_public_ip = "1.2.3.4"
subscription_id = "00000000-0000-0000-0000-000000000000"
# inject it as envirnoment variable : vpn_shared_key 
