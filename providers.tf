# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.92.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azapi" {
}

provider "azurerm" {
  features {}
}