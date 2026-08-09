variable "name_prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "azs" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}
