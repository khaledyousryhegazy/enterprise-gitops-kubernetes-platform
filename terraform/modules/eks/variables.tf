variable "name_prefix" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "eks_cluster_role_arn" {
  type = string
}

variable "eks_node_role_arn" {
  type = string
}

variable "vpc_cni_role_arn" {
  type = string
}

variable "ebs_csi_role_arn" {
  type = string
}

variable "kms_key_arn" {
  type = string
}
