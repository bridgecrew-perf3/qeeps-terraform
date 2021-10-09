variable "location" {
  type = string
}

variable "env" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "app_name" {
  type = string
}

variable "secrets" {
  type = map(string)
}

variable "ad_application_id" {
  type = string
}

variable "ad_application_secret" {
  type      = string
  sensitive = true
}

variable "ad_audience" {
  type = string
}

variable "ad_issuer" {
  type = string
}

variable "graph_api_object_id" {
  type = string
}

variable "graph_api_app_roles_ids" {
  type = map(string)
}

variable "ad_group_id" {
  type = string
}

variable "internal_role_id" {
  type = string
}

variable "ad_application_object_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "is_main" {
  type = bool
}

variable "use_function_proxy" {
  type = bool
}

variable "create_dev_resources" {
  type = bool
}
