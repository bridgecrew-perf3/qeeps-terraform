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
    type = map(string)
}

variable "kv_id" {
    type = string
}

variable "kv_url" {
    type = string
}