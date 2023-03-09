output "region" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region#name"
  value       = data.aws_region.current.name
}