variable "applications" {}
variable "vpc_cidr" {}
variable "common_tags" {}
variable "number_of_public_route_table" {}
variable "number_of_app_route_table" {}
variable "number_of_db_route_table" {}
variable "default_route_destination" {}
variable "app_tier_name" {}
variable "web_tier_name" {}
variable "db_tier_name" {}
#keypair
variable "public_key" {}
#EC2
variable "ami" {}
variable "instance_type" {}
variable "termination_protection" {}
variable "AZ" {}
