# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp"
resource "azurerm_resource_group" "sample" {
  location   = "centralindia"
  managed_by = null
  name       = "moduleex-rgp"
  tags       = {}
}

# __generated__ by Terraform
resource "azurerm_virtual_network" "sample" {
  address_space           = ["10.0.0.0/16"]
  bgp_community           = null
  dns_servers             = []
  edge_zone               = null
 # flow_timeout_in_minutes = 0
  location                = "centralindia"
  name                    = "moduleex-network"
  resource_group_name     = "moduleex-rgp"
  tags = {}
}

# __generated__ by Terraform
resource "azurerm_subnet" "sample" {
  address_prefixes                              = ["10.0.2.0/24"]
  name                                          = "internal"
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  resource_group_name                           = "moduleex-rgp"
  #service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  virtual_network_name                          = "moduleex-network"
}

# __generated__ by Terraform from "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp/providers/Microsoft.Network/publicIPAddresses/test-pip"
resource "azurerm_public_ip" "sample" {
  allocation_method       = "Dynamic"
  ddos_protection_mode    = "VirtualNetworkInherited"
  ddos_protection_plan_id = null
  domain_name_label       = null
  edge_zone               = null
  idle_timeout_in_minutes = 30
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = "centralindia"
  name                    = "test-pip"
  public_ip_prefix_id     = null
  resource_group_name     = "moduleex-rgp"
  reverse_fqdn            = null
  sku                     = "Basic"
  sku_tier                = "Regional"
  tags = {
    environment = "test"
  }
  zones = []
}

# __generated__ by Terraform from "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp/providers/Microsoft.Network/networkInterfaces/moduleex-nic"
resource "azurerm_network_interface" "sample" {
  auxiliary_mode                = null
  auxiliary_sku                 = null
  dns_servers                   = []
  edge_zone                     = null
  enable_accelerated_networking = false
  enable_ip_forwarding          = false
  internal_dns_name_label       = null
  location                      = "centralindia"
  name                          = "moduleex-nic"
  resource_group_name           = "moduleex-rgp"
  tags                          = {}
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = null
    name                                               = "internal"
    primary                                            = true
    private_ip_address                                 = "10.0.2.4"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp/providers/Microsoft.Network/publicIPAddresses/test-pip"
    subnet_id                                          = "/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp/providers/Microsoft.Network/virtualNetworks/moduleex-network/subnets/internal"
  }
}

# __generated__ by Terraform
resource "azurerm_linux_virtual_machine" "sample" {
  admin_password                                         = null # sensitive
  admin_username                                         = "adminuser"
  allow_extension_operations                             = true
  availability_set_id                                    = null
  bypass_platform_safety_checks_on_user_schedule_enabled = false
  capacity_reservation_group_id                          = null
  computer_name                                          = "moduleex-machine"
  custom_data                                            = null # sensitive
  dedicated_host_group_id                                = null
  dedicated_host_id                                      = null
  disable_password_authentication                        = false
  disk_controller_type                                   = null
  edge_zone                                              = null
  encryption_at_host_enabled                             = false
  eviction_policy                                        = null
  extensions_time_budget                                 = "PT1H30M"
  license_type                                           = null
  location                                               = "centralindia"
  max_bid_price                                          = -1
  name                                                   = "moduleex-machine"
  network_interface_ids                                  = ["/subscriptions/1bb88024-3ab4-4e44-b064-71e7d8e25281/resourceGroups/moduleex-rgp/providers/Microsoft.Network/networkInterfaces/moduleex-nic"]
  patch_assessment_mode                                  = "ImageDefault"
  patch_mode                                             = "ImageDefault"
  #platform_fault_domain                                  = -1
  priority                                               = "Regular"
  provision_vm_agent                                     = true
  proximity_placement_group_id                           = null
  reboot_setting                                         = null
  resource_group_name                                    = "moduleex-rgp"
  secure_boot_enabled                                    = false
  size                                                   = "Standard_F1"
  source_image_id                                        = null
  tags                                                   = {"AlwasyOn" = "True"}
  user_data                                              = null
  virtual_machine_scale_set_id                           = null
  vm_agent_platform_updates_enabled                      = false
  vtpm_enabled                                           = false
  zone                                                   = null
  os_disk {
    caching                          = "ReadWrite"
    disk_encryption_set_id           = null
    disk_size_gb                     = 30
    name                             = "moduleex-machine_OsDisk_1_1e6c1c6071994bb193a865b857645684"
    secure_vm_disk_encryption_set_id = null
    security_encryption_type         = null
    storage_account_type             = "Standard_LRS"
    write_accelerator_enabled        = false
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
