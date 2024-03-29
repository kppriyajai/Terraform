variable "client_id"{
  default = "c71c1f8c-66dd-480f-93da-9542667fe955"
}

variable "client_certificate_path" {
  default = "/root/mycert.pfx"
}

variable "tenant_id" {
  default =  "4999f284-1ea6-4fd0-a73c-217ae6ef7bec" 
}

variable "subscription_id" {
  default = "1bb88024-3ab4-4e44-b064-71e7d8e25281" 
}


variable "prefix" {
  default = "my-third-tf"
}

variable "location" {
  default = "Central India"
}

variable "myvm" {
  default = { size = "Standard_B1s", admin_username = "adminuser", admin_password = "kppriya#58" }
}
