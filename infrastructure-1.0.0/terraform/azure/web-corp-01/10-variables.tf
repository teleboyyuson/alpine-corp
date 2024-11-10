variable "rg_name" {
    type = string
}

variable "location" {
    type = string
}

variable "cidr_blocks" {
    type = list(string)
}

variable "subnet" {
    type = list(string)
}