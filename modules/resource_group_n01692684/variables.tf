variable "humber_id" {
  description = "Humber ID"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group"
  type        = string
}

variable "location" {
  description = "Location for the resource group"
  type        = string
}

variable "admin_username" {
  description = "admin username"
  type        = string
}
variable "private_key" {
  description = "The private key"
  type        = string
}

locals {
  tags = {
    Assignment     = "CCGC 5502 Automation Assignment"
    Name           = "Vijayalakshmi Govindarajan"
    ExpirationDate = "2024-12-31"
    Environment    = "Learning"
  }
}
variable "create_backend_rg" {
  type    = bool
  default = false # Change to true if creating the backend RG here
}
