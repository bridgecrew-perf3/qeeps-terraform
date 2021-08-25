variable "name" {
    type = string
}

variable "resource_group" {
    type = string
}

variable "cname" {
    type = string
}

variable "swa_hostnames" {
    type = list(string)
}

variable "access_hostnames" {
    type = list(string)
}

variable "forms_hostnames" {
    type = list(string)
}

variable "files_hostnames" {
    type = list(string)
}


variable "notifications_hostnames" {
    type = list(string)
}

variable "health_probe_interval" {
    type = number
}