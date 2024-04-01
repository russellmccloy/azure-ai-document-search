# NOTE: I don't use a backend to store my Terraform state as this is just a proof of concept.

# terraform {
#   backend "azurerm" {
#     resource_group_name  = "NOT_SET"
#     storage_account_name = "NOT_SET"
#     container_name       = "terraformstate"
#     key                  = "terraform.tfstate"
#   }
# }