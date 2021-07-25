variable "name" {
    type = string
}

variable "location" {
    type = string
}

variable "resource_group" {
    type = string
}


variable "storage_account_name" {
    type = string
}

variable "storage_account_access_key" {
    type = string
}

variable "app_service_plan_id" {
    type = string
}

variable "kv_id" {
    type = string
}

variable "app_configs" {
    type = map(string)
}