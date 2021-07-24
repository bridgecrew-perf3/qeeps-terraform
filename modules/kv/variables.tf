variable "name" {
    type = string
}

variable "location" {
    type = string
}

variable "resourceGroup" {
    type = string
}

variable "secrets" {
    type = map(any)
}