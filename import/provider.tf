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

import {
  to = azurerm_resource_group.sample
  id = "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp"
}


import {
  to = azurerm_subnet.sample
  id = "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp/providers/Microsoft.Network/virtualNetworks/moduleex-network/subnets/internal"
}

import {
  to = azurerm_virtual_network.sample
  id = "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp/providers/Microsoft.Network/virtualNetworks/moduleex-network"
}

import {
  to = azurerm_public_ip.sample
  id = "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp/providers/Microsoft.Network/publicIPAddresses/test-pip"
}

import {
  to = azurerm_network_interface.sample
  id = "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp/providers/Microsoft.Network/networkInterfaces/moduleex-nic"
}

import {
  to = azurerm_linux_virtual_machine.sample
  id = "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp/providers/Microsoft.Compute/virtualMachines/moduleex-machine"
}
