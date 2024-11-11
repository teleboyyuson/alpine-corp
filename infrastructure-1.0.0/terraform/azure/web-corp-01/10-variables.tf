variable "rg_name" {
    type = string
}

variable "location" {
    type = string
}

variable "vnet" {
    type = list(string)
}

variable "snet-pub" {
    type = list(string)
}

variable "snet-priv" {
    type = list(string)
}