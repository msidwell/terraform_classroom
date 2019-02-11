#Resource declarations
resource "azurerm_resource_group" "rg01" {
  name     = "${var.rg_name}"
  location = "${var.rg_location}"

  tags     = {
      env  = "${var.rg_env}"
  }
}