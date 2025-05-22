# PowerShell script to automate Terraform init with environment-specific tfstate key
param(
    [string]$EnvName = "dev",
    [string]$StorageAccount = "mystoragename"
)

$backendConfig = @(
    "resource_group_name=tfstate-rg"
    "storage_account_name=$StorageAccount"
    "container_name=tfstate"
    "key=terraform-$EnvName.tfstate"
)

$backendArgs = $backendConfig | ForEach-Object { "-backend-config=$_" }
terraform init @backendArgs

