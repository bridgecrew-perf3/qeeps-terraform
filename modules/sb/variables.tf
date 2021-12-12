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

variable "capacity" {
  type = number
}

variable "create_dev_queues" {
  type = bool
}
