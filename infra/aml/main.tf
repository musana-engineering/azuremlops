locals {
  location = "eastus2"
  tags = {
    provisioner = "terraform"
    project = "ai-operations"
  }

}

resource "azurerm_resource_group" "ml" {
  name     = "rg-aiops"
  location = local.location
  tags = local.tags
}

resource "azurerm_application_insights" "ml" {
  name                = "appi-aiops"
  location            = azurerm_resource_group.ml.location
  resource_group_name = azurerm_resource_group.ml.name
  application_type    = "web"
  tags = local.tags
}

resource "azurerm_key_vault" "ml" {
  name                = "kv-aiops"
  location            = azurerm_resource_group.ml.location
  resource_group_name = azurerm_resource_group.ml.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags = local.tags
}

resource "azurerm_storage_account" "ml" {
  name                     = "saaiops"
  location                 = azurerm_resource_group.ml.location
  resource_group_name      = azurerm_resource_group.ml.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_machine_learning_workspace" "ml" {
  name                    = "mlw-aiops"
  location                = azurerm_resource_group.ml.location
  resource_group_name     = azurerm_resource_group.ml.name
  application_insights_id = azurerm_application_insights.ml.id
  key_vault_id            = azurerm_key_vault.ml.id
  storage_account_id      = azurerm_storage_account.ml.id

  identity {
    type = "SystemAssigned"
  }
}