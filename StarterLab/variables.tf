variable "location-1" {
    type = string
    description = "primary location"
}
variable "location-2" {
  type = string
  description = "secondary location"
}

variable "vnet-address-space-01" {
  type = string
  description = "First address space for VNet"
}

variable "snet-infra-01" {
  type = string
  description = "Infrastructure Subnet Address Space"

}
variable "snet-app-01" {
  type = string
  description = "Application Subnet Address Space"
}

variable "snet-db-01" {
  type = string
  description = "Database Subnet Address Space"
}
variable "snet-iam-01" {
  type = string
  description = "IAM Subnet Address Space"
}

variable "vnet-address-space-02" {
  type = string
  description = "First address space for VNet"
}

variable "snet-infra-02" {
  type = string
  description = "Infrastructure Subnet Address Space"

}
variable "snet-app-02" {
  type = string
  description = "Application Subnet Address Space"
}

variable "snet-db-02" {
  type = string
  description = "Database Subnet Address Space"
}
variable "snet-iam-02" {
  type = string
  description = "IAM Subnet Address Space"
}