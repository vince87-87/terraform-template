resource "aws_ecs_cluster" "this" {
  count = var.ecs_cluster_create ? 1 : 0
  name = join("-",["${var.applications}","ecs",count.index+1])
  setting {
    name = "containerInsights"
    value = var.enable_containerInsights ? "enabled" : "disabled"
  }
  tags  = merge(
    {
      "Name" = var.tag_ecs_cluster_name
    },
      var.common_tags,
  )
#   configuration {
#     execute_command_configuration {
#       kms_key_id = var.kms_key_id
#       logging    = var.logging

#       log_configuration {
#         cloud_watch_encryption_enabled = var.cloud_watch_encryption_enabled
#         cloud_watch_log_group_name     = var.cloud_watch_log_group_name
#       }
#     }
#   }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  count = var.ecs_cluster_create ? 1 : 0
  cluster_name = aws_ecs_cluster.this[0].name

  capacity_providers = var.capacity_providers

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}