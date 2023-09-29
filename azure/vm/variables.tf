variable "azure_region" {
  description = "Azure Region"
  default = "East US"
}

variable "resource" {
  description = "Default resources name"
  default = "waf-re-shajiya"
}

variable "nap" {
  type = bool
}
variable "nic" {
  type = bool
}
variable "bigip" {
  type = bool
}
variable "bigip-cis" {
  type = bool
}

variable "project_prefix" {
  type        = string
#  default     = "demo"
  description = "This value is inserted at the beginning of each AWS object (alpha-numeric, no special character)"
}
