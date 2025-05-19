resource "aws_guardduty_organization_admin_account" "gd" {
  provider         = aws.org
  admin_account_id = local.delegated_admin #"526590817801"
  depends_on       = [local.org]
}

resource "aws_guardduty_detector" "delegated_admin" {
  #checkov:skip=CKV2_AWS_3:Temporary exception until TGRC reviews the code they created.
  count    = var.current_account == var.prod_master_payer ? 1 : 0
  enable   = true
  provider = aws.secsvcs
}

resource "aws_guardduty_organization_configuration" "delegated_admin" {
  provider    = aws.secsvcs
  #auto_enable = true
  auto_enable_organization_members = 'ALL'
  detector_id = local.detector_id ##var.current_account == var.prod_master_payer ? aws_guardduty_detector.delegated_admin[0].id : aws_guardduty_detector.org.id
  datasources {
    s3_logs {
      auto_enable = true
    }
    kubernetes {
      audit_logs {
        enable = true
      }
    }
    malware_protection {
        scan_ec2_instance_with_findings {
            ebs_volumes {
                enable = true
            }
        }
    }
  }
  # depends_on = [aws_guardduty_organization_admin_account.gd]
}

resource "aws_guardduty_organization_configuration_feature" "delegated_admin" {
  provider = aws.secsvcs
  for_each = toset(local.gd_protection_plans)

  detector_id = local.detector_id
  name = each.value
  auto_enable = "ALL"
}

resource "aws_guardduty_detector" "org" {
  #checkov:skip=CKV2_AWS_3:Temporary exception until TGRC reviews the code they created.
  enable   = true
  provider = aws.org
}

locals {
  gd_protection_plans = [ "RDS_LOGIN_EVENTS", "LAMBDA_NETWORK_LOGS" , "RUNTIME_MONITORING"]
}
