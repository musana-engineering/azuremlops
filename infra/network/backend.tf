terraform {
  backend "azurerm" {
    resource_group_name  = "rg-core"
    storage_account_name = "sacoreinfrastate"
    container_name       = "terraform"
    key                  = "core/networking.terraform.tfstate"
    # access_key           = 
  }
}


