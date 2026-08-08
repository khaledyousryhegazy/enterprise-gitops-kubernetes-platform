variable "name_prefix" {
  type = string
}

variable "tags" {
  type = list(map)
}

variable "azs" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}
