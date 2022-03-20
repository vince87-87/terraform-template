variable "ecs_cluster_create"{
  default = true
}
variable "applications" {}
variable "enable_containerInsights" {
  default = false
}
variable "tag_ecs_cluster_name" {}
variable "common_tags" {}
variable "capacity_providers" {
  type = list
  description = "Set of names of one or more capacity providers to associate with the cluster. Valid values also include FARGATE and FARGATE_SPOT."
  default = []
}
# variable "kms_key_id" {
#   default = null
# }
# variable "logging" {
#     description = "The log setting to use for redirecting logs for your execute command results. Valid values are NONE, DEFAULT, and OVERRIDE"
#     default = NONE
# }
# variable "cloud_watch_log_group_name" {}
# variable "cloud_watch_encryption_enabled" {
#     default = false
# }