variable "env" {
  type = string
  default = "stg"
}

variable "app_name" {
    type = string
    default = "qeeps"
}

variable "adminPassword" {
    type = string
    sensitive = true
}