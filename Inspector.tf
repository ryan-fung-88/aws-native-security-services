terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  alias = "org"
}
provider "aws" {
  region = var.aws_region
  alias = "securityservices"
}

resource "aws_inspector2_delegated_admin_account" "delegated_admin" {
  provider = aws.org
  account_id = var.delegated_admin_account_id
}

resource "aws_inspector2_enabler" "inspector_enabler" {
  provider = aws.org
  account_ids    = var.account_ids
  resource_types = ["EC2", "ECR", "Lambda"]
}

resource "aws_inspector2_organization_configuration" "organization_configuration" {
  provider = aws.securityservices
  auto_enable {
    ec2         = true
    ecr         = false
    lambda      = true
    lambda_code = true
  }
}

