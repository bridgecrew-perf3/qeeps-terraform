variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "tier" {
  type = string
}

variable "replication_type" {
  type = string
}

variable "access_tier" {
  type = string
}

variable "is_main" {
  type = bool
}

variable "all_locations" {
  type = map(string)
}
