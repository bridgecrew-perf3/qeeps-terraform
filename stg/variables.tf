variable "env" {
  type    = string
  default = "stg"
}

variable "app_name" {
  type    = string
  default = "qeeps"
}

variable "domain_name" {
  type    = string
  default = "stg.qeeps.io"
}


variable "app_hostname" {
  type    = string
  default = "app.stg.qeeps.io"
}

variable "adminpassword" {
  type      = string
  sensitive = true
}

variable "publicvapidkey" {
  type      = string
  sensitive = true
}

variable "privatevapidkey" {
  type      = string
  sensitive = true
}

variable "sendgridapikey" {
  type      = string
  sensitive = true
}

variable "all_locations" {
  type = map(string)
  default = {
    "West Europe" = "westeurope",
    # "West US 2"   = "westus2"
  }
}
