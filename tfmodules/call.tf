module "Mymodule" {
  source  = "/root/azurerm_vars"
  prefix = "moduleex"
}

output "Frommoduel" {
  value = module.Mymodule.my_public_ip
}
