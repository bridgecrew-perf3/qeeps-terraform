variable "name" {
    type = string
}

variable "resource_group" {
    type = string
}

variable "location" {
    type = string
}

variable "sku" {
    type = string
}

variable "family" {
    type = string
}

variable "capacity" {
    type = number
}

variable "sa_connection_string" {
    type = string
}

variable "aof_backup" {
    type = bool
}