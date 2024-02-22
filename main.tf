resource "azurerm_resource_group" "this" {
  name     = local.config.resource_groups.name
  location = local.config.resource_groups.location
}