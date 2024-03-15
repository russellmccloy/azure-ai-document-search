# output "identity_principal_id" {
#   value = azurerm_search_service.this.identity[0].principal_id
# }

output "azurerm_storage_account_id" {
  value     = azurerm_storage_account.this.id
  sensitive = false
}

# TODO: tidy up the outputs