variable "name_prefix" {
  type = string
}

variable "github_repository" {
  description = "GitHub repository in owner/repository format"
  type        = string
}

variable "rds_app_secret_arn" {
  description = "ARN of the application-only RDS credentials secret ESO may read."
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
