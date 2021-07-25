variable "env" {
  type = string
  default = "stg"
}

variable "app_name" {
    type = string
    default = "qeeps"
}

variable "domain_name" {
  type = string
  default = "stg.qeeps.io"
}

variable "admin_password" {
    type = string
    sensitive = true
}