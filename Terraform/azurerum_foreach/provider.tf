terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.97.1"
    }
  }
}

provider "azurerm" {
  features {}

  client_id                   = var.client_id
  client_certificate_path     = var.client_certificate_path
  tenant_id                   = var.tenant_id
  subscription_id             = var.subscription_id
}
