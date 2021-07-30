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

variable "kvl_id" {
    type = string
}

variable "kvl_url" {
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

variable "ad_issuer" {
    type = string
}

variable "appi_instrumentation_key" {
    type = string
}