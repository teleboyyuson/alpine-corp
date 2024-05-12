variable "vpc_name" {
  description = "Development VPC"
  type = string
}

variable "zone" {
  description = "Availability Zone"
  type = string
}

variable "cidr_blocks" {
  description = "Dev CIDR/Subnet"
  type = list(string)

}
