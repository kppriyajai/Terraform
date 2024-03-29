output "my_public_ip"{
 value = [
    for x in azurerm_linux_virtual_machine.example:
      x.public_ip_address
]
}

