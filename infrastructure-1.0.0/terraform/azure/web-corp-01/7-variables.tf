variable "rg_name" {
    type = string
}

variable "location" {
    type = string
}

variable "vnet" {
    type = list(string)
}

variable "snet" {
    type = list(string)
}