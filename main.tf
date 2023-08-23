locals {
  tags = {
    cost    = "shared"
    creator = "terraform"
    git     = var.git
  }
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "package.zip"
}

module "this" {
  source              = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.125-c7d3b7d"
  enable_cw_event     = var.enable
  enable_function_url = false
  enable_vpc          = var.vpc_id != null ? true : false
  filename            = data.archive_file.this.output_path
  git                 = var.git
  handler             = "vpn_keep_alive.handler"
  memory_size         = var.memory_size
  name                = var.name != null ? var.name : "vpn-keep-alive"
  private_subnet_ids  = var.private_subnet_ids
  retention_in_days   = var.retention_in_days
  runtime             = "python3.9"
  schedule_expression = "cron(*/${var.interval_minutes} * * * ? *)"
  source_code_hash    = data.archive_file.this.output_base64sha256
  tags                = merge(local.tags, var.tags)
  timeout             = var.timeout + 1
  vpc_id              = var.vpc_id

  environment = {
    HOST    = var.host
    PORT    = var.port
    TIMEOUT = var.timeout
  }
}