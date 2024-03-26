# TODO: Tidy up all Terraform and run TF fmt

resource "azurerm_resource_group" "this" {
  name     = "${local.prefix_name}-${local.config.resource_group.name}"
  location = local.config.resource_group.location
}

resource "azurerm_search_service" "this" {
  name                = "${local.prefix_name}-${local.config.azurerm_search_service.name}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = local.config.azurerm_search_service.sku
}

resource "azurerm_storage_account" "this" {
  name                     = "${local.prefix_name}${local.config.azurerm_storage_account.name}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
}

resource "azurerm_storage_container" "this" {
  name                  = "${local.prefix_name}-${local.config.azurerm_storage_container.name}"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = local.config.azurerm_storage_container.access_type # for this proof of concept the container type not private but it should be to ensure the security of your documents
}