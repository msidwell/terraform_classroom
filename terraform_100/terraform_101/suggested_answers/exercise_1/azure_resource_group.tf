resource "azurerm_resource_group" "rg01" {
  name = "my-fresh-resource-group"
  location = "eastus2"

  tags = {
      env = "dev"
  }
}