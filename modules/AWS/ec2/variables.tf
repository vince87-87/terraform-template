variable "create_instance" {
  default = true
}
variable "number_of_instance" {
  default = 1
}
variable "ami" {}
variable "instance_type" {}
variable "associate_public_ip_address" {
  default = null
}
variable "AZ" {}
variable "termination_protection" {
  default = true
}
variable "iam_roles" {
    default = null
}
variable "sg_id" {}
variable "get_password_data" {
  default = null
}
variable "private_ip" {
  default = null
}
variable "secondary_private_ips" {
  default = null
}
variable "keypair" {
    default = null
}
variable "monitoring" {
  default = false
}
variable "subnet_id" {}
variable "user_data" {
  default = null
}
variable "tag_ec2_name" {}
variable "common_tags" {}
variable "root_block_device" {}
# variable "ebs_block_device" {}
