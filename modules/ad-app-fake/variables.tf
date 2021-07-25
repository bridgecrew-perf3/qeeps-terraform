variable "name" {
    type = string
}

variable "application_id" {
    type = string
}

variable "object_id" {
    type = string
}

variable "application_secret" {
    type = string
    sensitive = true
}