#Variable declarations
variable "azure_sub_id" {
    description   = "Azure subscription ID"
}

variable "azure_client_id" {
  description = "Azure SP user ID"
}

variable "azure_client_secret" {
  description = "Azure SP user secret"
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
}
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