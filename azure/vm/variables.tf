variable "azure_region" {
  description = "Azure Region"
  default = "East US"
}

variable "resource" {
  description = "Default resources name"
  default = "waf-re-jb"
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
