data "aws_vpcs" "this" {
  tags = {
    purpose = "vega"
  }
}

data "aws_subnets" "this" {
  tags = {
    purpose = "vega"
    Type    = "Private"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

module "this" {
  source             = "../../"
  enable             = true
  git                = "terraform-aws-vpn-keep-alive"
  host               = "github.com"
  interval_minutes   = 1
  name               = "test"
  port               = 80
  private_subnet_ids = data.aws_subnets.this.ids
  retention_in_days  = 7
  timeout            = 1
  vpc_id             = data.aws_vpcs.this.ids[0]
}

output "cloudwatch_log_group" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group"
  value       = module.this.cloudwatch_log_group
}
