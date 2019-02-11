#Variable declarations
variable "rg_name" {
  type        = "string"
  description = "Name for new resource group"
  default     = "my-fresh-resource-group"
}

variable "rg_location" {
  type        = "string"
  description = "Location for new resource group"
  default     = "eastus2"
}

variable "rg_env" {
  type        = "string"
  description = "Env tag for new resource group"
  default     = "eastus2"
}


#Resource declarations
resource "azurerm_resource_group" "rg01" {
  name     = "${var.rg_name}"
  location = "${var.rg_location}"

  tags     = {
      env  = "${var.rg_env}"
  }
}