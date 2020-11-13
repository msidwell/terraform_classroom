#Provider declaration

provider "azurerm" {
    version         = "~> 1.22"
    subscription_id = var.azure_sub_id
    client_id       = var.azure_client_id
    client_secret   = var.azure_client_secret
    tenant_id       = var.azure_tenant_id
}

#Resource declarations
resource "azurerm_resource_group" "rg01" {
  name     = var.rg_name
  location = var.rg_location

  tags     = {
      env  = var.rg_env
  }
}