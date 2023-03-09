terraform {
  backend "s3" {}
}

provider "aws" {
  region = "us-east-2"
}

data "aws_region" "current" {}

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
  port               = 80
  private_subnet_ids = data.aws_subnets.this.ids
  retention_in_days  = 7
  timeout            = 1
  vpc_id             = data.aws_vpcs.this.ids[0]
}
