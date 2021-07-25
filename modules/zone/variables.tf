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

variable "ad_application_id" {
    type = string
}

variable "ad_application_secret" {
    type = string
    sensitive = true
}

variable "ad_audience" {
    type = string
}