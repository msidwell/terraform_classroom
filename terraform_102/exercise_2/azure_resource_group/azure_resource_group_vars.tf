#Variable declarations
variable "azure_sub_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "azure_client_id" {
  type        = string
  description = "Azure SP user ID"
}

variable "azure_client_secret" {
  type        = string
  description = "Azure SP user secret"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant ID"
}
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