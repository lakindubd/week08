terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  # Avoids the AzureRM v4 provider-registration hang we hit in 6.1P
  resource_provider_registrations = "none"
  features {}
}