variable "common_tags" {}
variable "vpcid" {}
variable "application_name" {}
variable "security_group" {}
variable "ingress_rule" {}
variable "ingress_rule_sourceid" {
  default = null
}
variable "number_of_ingress_rule" {
  default = null
}
variable "create_SG_Cidr_Block" {
  default = false
}
variable "create_SG_SourceSG_ID" {
  default = false
}
variable "fromport" {
  default = null
}
variable "toport" {
  default = null
}
variable "protocol" {
  default = null
}
variable "sourcesgid" {
  default = null
}
variable "security_group_id" {
  default = null
}