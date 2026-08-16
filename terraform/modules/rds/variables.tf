variable "name_prefix" {
  type = string
}

variable "database_subnets" {
  type = list(string)
}

variable "db_security_group_id" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "kms_key_arn" {
  type = string
}
