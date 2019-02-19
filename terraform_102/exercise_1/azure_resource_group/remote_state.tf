terraform {
  backend "azurerm" {
    storage_account_name = "prdtrrfrmstaterepo"
    container_name       = "terraformbackend"
    access_key           = "1all2Kinds3Of4Alpha5Numeric6Stuff"
	key                  = "rg_state.tfstate"
  }
}