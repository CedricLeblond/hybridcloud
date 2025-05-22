# Azure Hybrid Cloud Landing Zone with VPN (Terraform)

This project bootstraps a secure Azure landing zone for hybrid cloud scenarios using Terraform. It provisions core networking resources and establishes a site-to-site VPN connection to your on-premises datacenter.

## Features
- Resource group, virtual network, and GatewaySubnet
- Azure VPN Gateway with Standard SKU public IP
- Local network gateway for on-premises representation
- Site-to-site VPN connection (shared key managed as a secret)
- Network Security Group (NSG) for custom rules (not applied to GatewaySubnet)
- Log Analytics workspace and diagnostic settings for NSG logging
- Tagging best practices for all resources
- Environment variable and tfvars support for secrets and configuration
- .gitignore and .env templates for secure local development

## Usage
1. **Configure variables:**
   - Edit `env/dev.tfvars` or use a `.env` file for secrets and environment-specific values.
2. **Initialize Terraform:**
   - `terraform init -var-file="env/dev.tfvars"`
   - Or load your `.env` file and run `terraform init`
3. **Plan and apply:**
   - `terraform plan -var-file="env/dev.tfvars"`
   - `terraform apply -var-file="env/dev.tfvars"`
4. **State management:**
   - Remote state backend (Azure Storage) is recommended for team use.

## Notes
- Do not associate an NSG with the GatewaySubnet (Azure restriction).
- Do not commit `.env` files containing secrets.
- The VPN shared key should be provided securely (via environment variable or secret store).

## Prerequisites
- Terraform CLI
- Azure CLI (for authentication)
- PowerShell module `pwsh-dotenv` (optional, for .env support)

## Quickstart
```powershell
# Load .env (optional, for secrets)
Import-Module pwsh-dotenv
Import-Dotenv .\.env

# Run Terraform
./tf init -var-file="env/dev.tfvars"
./tf plan -var-file="env/dev.tfvars"
./tf apply -var-file="env/dev.tfvars"
```
