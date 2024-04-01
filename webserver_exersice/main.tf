resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rgp"
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                    = "test-pip"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id

  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "${var.prefix}-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = var.myvm.admin_username
  admin_password      = var.myvm.admin_password
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  
  provisioner "local-exec" {
    command = "echo Helloworld;echo ${self.public_ip_address} > myfile.txt;echo echo Starting > myscript.sh ; echo sleep 20 >> myscript.sh ;echo echo Running >> myscript.sh ; echo sleep 20 >> myscript.sh ; echo echo Finishing >> myscript.sh;"
  }

  provisioner "file" {
    source = "web.sh"
    destination = "/tmp/web.sh"
     connection {
      type = "ssh"
      user = var.myvm.admin_username
      password = var.myvm.admin_password
      host = self.public_ip_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 755 /tmp/web.sh",
      "sudo /bin/sh /tmp/web.sh"
    ]
    connection {
      type = "ssh"
      user = var.myvm.admin_username
      password = var.myvm.admin_password
      host = self.public_ip_address
    } 
  }
}
