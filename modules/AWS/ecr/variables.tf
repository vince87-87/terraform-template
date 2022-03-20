variable "create_ecr" {
    default = true
}
variable "applications" {}
variable "image_tag_mutability" {
    description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
    default = "MUTABLE"
}
variable "enable_scan" {
    default = false
}
variable "encryption_type" {
    description = "The encryption type to use for the repository. Valid values are AES256 or KMS"
    default = "AES256"
}
variable "kms_key" {
    default = null
}
variable "tag_name_ecr" {}
variable "common_tags" {}