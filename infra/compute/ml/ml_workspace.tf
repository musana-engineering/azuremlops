locals {
  location  = "eastus2"
  tenant_id = "2f1f01b6-2930-4e0d-9a49-26873accbaae"
  tags = {
    provisioner = "terraform"
    project     = "ai-operations"
  }

}

resource "azurerm_resource_group" "ml" {
  name     = "rg-coreml"
  location = local.location
  tags     = local.tags
}

resource "azurerm_application_insights" "ml" {
  name                = "coreml"
  location            = azurerm_resource_group.ml.location
  resource_group_name = azurerm_resource_group.ml.name
  application_type    = "web"
  tags                = local.tags
}

resource "azurerm_key_vault" "ml" {
  name                = "coreml"
  location            = azurerm_resource_group.ml.location
  resource_group_name = azurerm_resource_group.ml.name
  tenant_id           = local.tenant_id
  sku_name            = "standard"
  tags                = local.tags
}

resource "azurerm_storage_account" "ml" {
  name                     = "sacoreml"
  location                 = azurerm_resource_group.ml.location
  resource_group_name      = azurerm_resource_group.ml.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_machine_learning_workspace" "ml" {
  name                    = "coreml"
  location                = azurerm_resource_group.ml.location
  resource_group_name     = azurerm_resource_group.ml.name
  application_insights_id = azurerm_application_insights.ml.id
  key_vault_id            = azurerm_key_vault.ml.id
  storage_account_id      = azurerm_storage_account.ml.id
  high_business_impact    = true
  tags                    = local.tags
  friendly_name           = "coreml"

  managed_network {
    isolation_mode = "AllowInternetOutbound"
  }

  identity {
    type = "SystemAssigned"
  }
}