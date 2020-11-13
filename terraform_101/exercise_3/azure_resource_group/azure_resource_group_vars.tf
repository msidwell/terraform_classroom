#Variable declarations
variable "rg_name" {
  type        = string
  description = "Name for new resource group"
  default     = "my-fresh-resource-group"
}

variable "rg_location" {
  type        = string
  description = "Location for new resource group"
  default     = "eastus2"
}

variable "rg_env" {
  type        = string
  description = "Env tag for new resource group"
  default     = "eastus2"
}