variable "location" {
    type = string
}

variable "env" {
    type = string
}

variable "app_name" {
    type = string
}

variable "secrets" {
    type = map(any)
}