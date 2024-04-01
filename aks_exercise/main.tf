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

  client_id                   = "c71c1f8c-66dd-480f-93da-9542667fe955"
  client_certificate_path     = "/root/mycert.pfx"
  tenant_id                   = "4999f284-1ea6-4fd0-a73c-217ae6ef7bec"
  subscription_id             = "1bb88024-3ab4-4e44-b064-71e7d8e25281"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "Central India"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "priya-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

}
resource "local_file" "example" {
  content  = azurerm_kubernetes_cluster.example.kube_config_raw
  filename = "config"
}
