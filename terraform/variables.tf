variable "location" {
  type    = string
  default = "australiaeast"
}

variable "resource_group_name" {
  type    = string
  default = "koalatech-week08-rg"
}

variable "acr_name" {
  type    = string
  default = "koalaacr8255e2"
}

variable "aks_cluster_name" {
  type    = string
  default = "koala-aks-week08"
}

variable "storage_account_name" {
  type    = string
  default = "koalastore8255e2"
}

variable "node_count" {
  type    = number
  default = 3
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s_v2"
}