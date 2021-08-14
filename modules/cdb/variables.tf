variable "name" {
    type = string
}

variable "resource_group" {
    type = string
}

variable "free" {
    type = bool
}

variable "multi_master" {
    type = bool
}

variable "locations" {
    type = list(string)
}

variable "serverless" {
    type = bool
}