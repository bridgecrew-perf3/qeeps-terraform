variable "name" {
    type = string
}

variable "allowed_role_names" {
    type = list(string)
    default = []
}