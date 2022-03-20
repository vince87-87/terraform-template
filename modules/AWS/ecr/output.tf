output "ecr_arn" {
  value = aws_ecr_repository.this.*.arn
}
output "respository_url" {
    value = aws_ecr_repository.this.*.repository_url
}
output "respository_id" {
    value = aws_ecr_repository.this.*.registry_id
}
