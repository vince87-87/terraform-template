variable "vpc_name" {}
variable "application_name" {}
variable "internetgw_name" {}
variable "pubic_route_table_name" {}
variable "app_route_table_name" {}
variable "db_route_table_name" {}
variable "number_of_public_route_table" {}
variable "number_of_app_route_table" {}
variable "number_of_db_route_table" {}
variable "number_of_nat_gateway" {
  description = "Number of nat gateway you want to provision"
  type        = number
  default     = null
}
variable "number_of_eip" {
  description = "Number of elastic ip you want to provision"
  type        = number
  default     = null
}
variable "vpc_tags" {}
variable "subnet_tags" {}
variable "vpc_cidr_block" {}
variable "instance_tenancy" {
  type    = string
  default = "default"
}
variable "public_subnet" {}
variable "app_subnet" {}
variable "db_subnet" {}
variable "common_tags" {}
variable "enable_dns_support" {
  type    = bool
  default = true
}
variable "enable_dns_hostnames" {
  type    = bool
  default = true
}
variable "enable_classiclink" {
  type    = bool
  default = false
}
variable "enable_classiclink_dns_support" {
  type    = bool
  default = false
}
variable "preferred_number_of_public_subnets" {
  type    = number
  default = null
}
variable "preferred_number_of_app_subnets" {
  type = number
  default = null
}
variable "preferred_number_of_db_subnets" {
  type = number
  default = null
}
variable "nat_connectivity_type" {
  type    = string
  default = "public"
}
variable "default_route_destination" {}