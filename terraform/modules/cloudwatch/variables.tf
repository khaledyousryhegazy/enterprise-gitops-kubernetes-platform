variable "name_prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "metric_transformation_name" {
  type = string
}

variable "metric_transformation_namespace" {
  type = string
}

variable "email_endpoint" {
  type = string
}
