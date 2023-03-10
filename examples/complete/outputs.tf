output "cloudwatch_log_group" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group"
  value       = module.this.cloudwatch_log_group
}

output "region" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region#name"
  value       = data.aws_region.current.name
}