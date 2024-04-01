locals {
  myjsondata = jsondecode(file("myjson.json"))
  mycsvdata = csvdecode(file("mycsv.csv"))
  
}

output "PrintJsonvalue" {
  value = local.myjsondata

}

output "PrintCSVvalue" {
  value = local.mycsvdata
}

output "PrintuatuserfromJson" {
  value = local.myjsondata.Project.0.Username
}

output "Printprduserfromcsv" {
  value = local.mycsvdata.0.username
}

variable "myname" {
 }

output "Printenvariable" {
  value = var.myname
}
