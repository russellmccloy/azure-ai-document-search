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

  # identity {
  #   type = "SystemAssigned"
  # }
}

resource "azurerm_storage_account" "this" {
  name                     = "${local.prefix_name}${local.config.azurerm_storage_account.name}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  # identity {
  #   type = "SystemAssigned"
  # }

  // TODO: add the search service managed identity as a 'Storage Blob Data Reader' to the storage account
}

resource "azurerm_storage_container" "this" {
  name                  = "${local.prefix_name}-${local.config.azurerm_storage_container.name}"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = local.config.azurerm_storage_container.access_type # for the demo it's not private but it should be
}

# resource "azurerm_role_assignment" "this" {
#   scope                = azurerm_storage_account.this.id
#   role_definition_name = "Storage Blob Data Reader" # We need this so the Azure AI Search service can read the Storage Account
#   principal_id         = azurerm_search_service.this.identity[0].principal_id
# }

# resource "azurerm_cognitive_account" "this" {
#   name                = "${local.prefix_name}-${local.config.azurerm_cognitive_account_document_intelligence.name}"
#   resource_group_name = azurerm_resource_group.this.name
#   location            = azurerm_resource_group.this.location
#   kind                = "FormRecognizer"

#   sku_name = "S0"

#   identity {
#     type = "SystemAssigned"
#   }
# }