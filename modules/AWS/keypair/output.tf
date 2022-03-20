output "key_name" {
  description = "The key pair name"
  value       = aws_key_pair.this.*.key_name
}