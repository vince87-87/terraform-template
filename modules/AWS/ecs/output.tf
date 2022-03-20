output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.*.arn
}

output "aws_ecs_cluster_capacity_providers_name" {
  value = aws_ecs_cluster_capacity_providers.this.*.id
}