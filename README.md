Install Terraform --->
1)  yum install -y yum-utils
2)  yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
3)  yum -y install terraform
4) terraform version

###############################################

1) Go to https://alh.learnondemand.net/
2) Register with Training Key:
60900FA61AF94726	Abhijan
1A76713B81CC43BA	Dinesh
54FECA14FB7449A0	Rajesh Balagam
7168582F960A40C1	Kumaran
2BBCBA4FFD8C42E1	Mahendra
5602A0952BA244E5	Padmapriya
58E005459E754072	Pankaj
BF923573974A4C84	Rajagopal
B12EC63A7F784646	Ravindra
D1BA9CBA26D24540	Smarak
C2017502D5BC4BDF	Srinivasa Vithal


3) Click on Register after entering your key
4) Fill in details and click Save.
5) Accept Agreement and Launch Lab.
6) Under Resources, get Promo Code. Save it on your system.

##################################################

Redeem using https://www.microsoftazurepass.com/

###################################################

Balance Check: https://www.microsoftazuresponsorships.com/balance

###################################################

Create CSR using openssl
openssl req -newkey rsa:4096 -nodes -keyout "mycert.key" -out "mycert.csr"


Signing CSR
openssl x509 -signkey "mycert.key" -in "mycert.csr" -req -days 30 -out "mycert.crt"

Creating PFX
openssl pkcs12 -export -out "mycert.pfx" -inkey "mycert.key" -in "mycert.crt"

###################################################

Use WinScp(C:\DevOps_Setup_Rocky) to copy certificate (mycert.crt) on Windows Desktop
IP: 192.168.49.128
UserName: root
Password: wfuser

###################################################

Open your Azure Portal on Lab machine.

###################################################


[root@master ~]# cd
[root@master ~]# mkdir azure_vm/    ^C
[root@master ~]# cd azure_vm/
[root@master azure_vm]# cat main.tf
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
  client_id                   = "37a0369c-41ef-43bb-bb6c-27ea9f246ce0"
  client_certificate_path     = "/root/mycert.pfx"
  tenant_id                   = "df8af829-df8a-41fe-8679-3e0a616165c5"
  subscription_id             = "bbbd26d1-25ec-4756-8dd7-085194738e44"
}


resource "azurerm_resource_group" "example" {
  name     = "sagar-rg"
  location = "Central India"
}

resource "azurerm_virtual_network" "example" {
  name                = "sagar-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "sagar-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "sagar-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "sagar-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  admin_password      = "Sagar@123@Sagar"
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
}
[root@master azure_vm]# terraform init     ^C
[root@master azure_vm]# terraform validate    ^C
[root@master azure_vm]# terraform plan    ^C
[root@master azure_vm]# terraform apply    ^C
[root@master azure_vm]# ls -tlr terraform.tfstate
-rw-r--r-- 1 root root 10484 Mar 28 16:03 terraform.tfstate


################################################

[root@master azure_vm]# terraform destroy          ^C
[root@master azure_vm]#
[root@master azure_vm]# terraform destroy -target=azurerm_linux_virtual_machine.example      ^C


################################################

terraform {
  backend "local" {
    path = "/etc/myfile"
  }

  backend "artifactory" {
    path = "https://myartficatory.shell.com/projectname/foldername/filename"
  }

  backend "http" {
   path = "someurl"
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.97.1"
    }
  }
}

####################################################




[root@master ~]# cd
[root@master ~]# mkdir azure_vars/    ^C
[root@master ~]# cd azure_vars/
[root@master azure_vars]# cat vars.tf
variable "client_id" {
  default = "37a0369c-41ef-43bb-bb6c-27ea9f246ce0"
}

variable "client_certificate_path" {
  default = "/root/mycert.pfx"
}

variable "tenant_id" {
  default = "df8af829-df8a-41fe-8679-3e0a616165c5"
}

variable "subscription_id" {
  default = "bbbd26d1-25ec-4756-8dd7-085194738e44"
}

variable "prefix" {
  default = "sagar"
}

variable "location" {
  default = "Central India"
}

variable "myvm" {
  default = { size = "Standard_B1s", admin_username = "adminuser", admin_password = "Sagar@123@Sagar" }
}
[root@master azure_vars]# cat provider.tf
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
[root@master azure_vars]# cat main.tf
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "${var.prefix}-pubip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "${var.prefix}-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.myvm.size
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
}
[root@master azure_vars]# cat out.tf
output "MyPublicIP" {
  value = azurerm_linux_virtual_machine.example.public_ip_address
}
[root@master azure_vars]# terraform init    ^C
[root@master azure_vars]# terraform validate       ^C
[root@master azure_vars]# terraform plan           ^C
[root@master azure_vars]# terraform apply -auto-approve      ^C

#################################################################

[root@master ~]# cd
[root@master ~]# mkdir azure_prov/    ^C
[root@master ~]# cd azure_prov/
[root@master azure_prov]# cp -fr ../azure_vars/*.tf .            ^C
[root@master azure_prov]# cat main.tf
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "${var.prefix}-pubip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}


resource "azurerm_linux_virtual_machine" "example" {
  name                = "${var.prefix}-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.myvm.size
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
    command = "echo ${self.public_ip_address} > myfile"
  }

  provisioner "local-exec" {
    command = "echo echo Starting > myscript.sh ; echo sleep 20 >> myscript.sh ; echo echo Running >> myscript.sh ; echo sleep 20 >> myscript.sh ; echo echo Finishing >> myscript.sh"
  }

  provisioner "file" {
    source = "myscript.sh"
    destination = "/tmp/myscript.sh"
    connection {
      type = "ssh"
      user = var.myvm.admin_username
      password = var.myvm.admin_password
      host = self.public_ip_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 755 /tmp/myscript.sh",
      "sudo /bin/sh /tmp/myscript.sh"
    ]
    connection {
      type = "ssh"
      user = var.myvm.admin_username
      password = var.myvm.admin_password
      host = self.public_ip_address
    }
  }
}
[root@master azure_prov]# terraform init   ^C
[root@master azure_prov]# terraform plan    ^C
[root@master azure_prov]# terraform apply -auto-approve   ^C


#####################################################

[root@master ~]# cd
[root@master ~]# mkdir azure_count/   ^C
[root@master ~]# cd azure_count/
[root@master azure_count]# cp -fr ../azure_vars/*.tf .      ^C
[root@master azure_count]# cat main.tf
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

#azurerm_public_ip.example[0]
#azurerm_public_ip.example[1]
#azurerm_public_ip.example[2]
resource "azurerm_public_ip" "example" {
  count = 3
  name                = "${var.prefix}-pubip-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

#azurerm_network_interface.example[0]
#azurerm_network_interface.example[1]
#azurerm_network_interface.example[2]
resource "azurerm_network_interface" "example" {
  count = 3
  name                = "${var.prefix}-nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[count.index].id
  }
}

#azurerm_linux_virtual_machine.example[0]
#azurerm_linux_virtual_machine.example[1]
#azurerm_linux_virtual_machine.example[2]
resource "azurerm_linux_virtual_machine" "example" {
  count = 3
  name                = "${var.prefix}-vm-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.myvm.size
  admin_username      = var.myvm.admin_username
  admin_password      = var.myvm.admin_password
  disable_password_authentication = "false"

  network_interface_ids = [
    azurerm_network_interface.example[count.index].id,
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
}
[root@master azure_count]# cat out.tf
output "MyPublicIP" {
  value = azurerm_linux_virtual_machine.example[*].public_ip_address
}
[root@master azure_count]# terraform init    ^C
[root@master azure_count]# terraform plan     ^C
[root@master azure_count]# terraform apply -auto-approve     ^C
[root@master azure_count]# terraform state list
azurerm_linux_virtual_machine.example[0]
azurerm_linux_virtual_machine.example[1]
azurerm_linux_virtual_machine.example[2]
azurerm_network_interface.example[0]
azurerm_network_interface.example[1]
azurerm_network_interface.example[2]
azurerm_public_ip.example[0]
azurerm_public_ip.example[1]
azurerm_public_ip.example[2]
azurerm_resource_group.example
azurerm_subnet.example
azurerm_virtual_network.example



########################################################

[root@master ~]# cd
[root@master ~]# mkdir azure_foreach/   ^C
[root@master ~]# cd azure_foreach/
[root@master azure_foreach]# cp -fr ../azure_vars/*.tf .    ^C
[root@master azure_foreach]# cat vars.tf | tail -4

variable "mymap" {
  default = { blr = ["B1s", "blruser"], hyd = ["B1ls", "hyduser"], mum = ["F2", "mumuser"] }
}
[root@master azure_foreach]# cat main.tf
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

#azurerm_public_ip.example["blr"]
#azurerm_public_ip.example["hyd"]
#azurerm_public_ip.example["mum"]
resource "azurerm_public_ip" "example" {
  for_each = var.mymap
  name                = "${var.prefix}-pubip-${each.key}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

#azurerm_network_interface.example["blr"]
#azurerm_network_interface.example["hyd"]
#azurerm_network_interface.example["mum"]
resource "azurerm_network_interface" "example" {
  for_each = var.mymap
  name                = "${var.prefix}-nic-${each.key}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[each.key].id
  }
}

#azurerm_linux_virtual_machine.example["blr"]
#azurerm_linux_virtual_machine.example["hyd"]
#azurerm_linux_virtual_machine.example["mum"]
resource "azurerm_linux_virtual_machine" "example" {
  for_each = var.mymap
  name                = "${var.prefix}-vm-${each.key}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_${each.value[0]}"
  admin_username      = each.value[1]
  admin_password      = var.myvm.admin_password
  disable_password_authentication = "false"

  network_interface_ids = [
    azurerm_network_interface.example[each.key].id,
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
}
[root@master azure_foreach]# cat out.tf
output "MyPublicIPs" {
  value = [
    for x in azurerm_linux_virtual_machine.example:
      x.public_ip_address
  ]
}


#####################################################


[root@master ~]# cd
[root@master ~]# mkdir azure_ifelse/   ^C
[root@master ~]# cd azure_ifelse/
[root@master azure_ifelse]# cp -fr ../azure_count/*.tf .      ^C
[root@master azure_ifelse]# cat vars.tf | tail -3

variable "env" {
}
[root@master azure_ifelse]# cat main.tf
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

#azurerm_public_ip.example[0]
#azurerm_public_ip.example[1]
#azurerm_public_ip.example[2]
resource "azurerm_public_ip" "example" {
  count = "${ var.env == "prd" ? 3 : var.env == "uat" ? 2 : 1 }"
  name                = "${var.prefix}-pubip-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

#azurerm_network_interface.example[0]
#azurerm_network_interface.example[1]
#azurerm_network_interface.example[2]
resource "azurerm_network_interface" "example" {
  count = "${ var.env == "prd" ? 3 : var.env == "uat" ? 2 : 1 }"
  name                = "${var.prefix}-nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[count.index].id
  }
}

#azurerm_linux_virtual_machine.example[0]
#azurerm_linux_virtual_machine.example[1]
#azurerm_linux_virtual_machine.example[2]
resource "azurerm_linux_virtual_machine" "example" {
  count = "${ var.env == "prd" ? 3 : var.env == "uat" ? 2 : 1 }"
  name                = "${var.prefix}-vm-${count.index}-${var.env}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.myvm.size
  admin_username      = var.myvm.admin_username
  admin_password      = var.myvm.admin_password
  disable_password_authentication = "false"

  network_interface_ids = [
    azurerm_network_interface.example[count.index].id,
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
}

#####################################################


[root@master ~]# cd
[root@master ~]# mkdir azure_template/   ^C
[root@master ~]# cd azure_template/
[root@master azure_template]# cp -fr ../azure_ifelse/*.tf .     ^C
[root@master azure_template]# DELETED variable "env" BLOCK from vars.tf    ^C
[root@master azure_template]# cat main.tf
#trimspace(data.template_file.myenv.rendered)
data "template_file" "myenv" {
  template = file("${path.module}/env")
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

#azurerm_public_ip.example[0]
#azurerm_public_ip.example[1]
#azurerm_public_ip.example[2]
resource "azurerm_public_ip" "example" {
  count = "${ trimspace(data.template_file.myenv.rendered) == "prd" ? 3 : trimspace(data.template_file.myenv.rendered) == "uat" ? 2 : 1 }"
  name                = "${var.prefix}-pubip-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

#azurerm_network_interface.example[0]
#azurerm_network_interface.example[1]
#azurerm_network_interface.example[2]
resource "azurerm_network_interface" "example" {
  count = "${ trimspace(data.template_file.myenv.rendered) == "prd" ? 3 : trimspace(data.template_file.myenv.rendered) == "uat" ? 2 : 1 }"
  name                = "${var.prefix}-nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[count.index].id
  }
}

#azurerm_linux_virtual_machine.example[0]
#azurerm_linux_virtual_machine.example[1]
#azurerm_linux_virtual_machine.example[2]
resource "azurerm_linux_virtual_machine" "example" {
  count = "${ trimspace(data.template_file.myenv.rendered) == "prd" ? 3 : trimspace(data.template_file.myenv.rendered) == "uat" ? 2 : 1 }"
  name                = "${var.prefix}-vm-${count.index}-${trimspace(data.template_file.myenv.rendered)}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.myvm.size
  admin_username      = var.myvm.admin_username
  admin_password      = var.myvm.admin_password
  disable_password_authentication = "false"

  network_interface_ids = [
    azurerm_network_interface.example[count.index].id,
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
}
[root@master azure_template]# cat env
 sagar


##############################################################




