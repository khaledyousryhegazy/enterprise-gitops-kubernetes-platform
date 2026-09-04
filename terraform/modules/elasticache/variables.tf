variable "name_prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}
