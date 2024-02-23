resource "azurerm_resource_group" "this" {
  name     = local.config.resource_group.name
  location = local.config.resource_group.location
}

resource "azurerm_search_service" "this" {
  name                = local.config.azurerm_search_service.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "basic"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_account" "this" {
  name                     = local.config.azurerm_storage_account.name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_container" "this" {
  name                  = local.config.azurerm_storage_account.name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}