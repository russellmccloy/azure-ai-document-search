# terraform {
#   backend "azurerm" {
#     resource_group_name  = "terraform-rg"
#     storage_account_name = "terraformsaclearbank"
#     container_name       = "terraformstate"
#     key                  = "terraform.tfstate"
#   }
# }