variable "name_prefix" {
  type = string
}

variable "github_repository" {
  description = "GitHub repository in owner/repository format"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}