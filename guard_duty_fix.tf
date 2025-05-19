
# This is enabling the S3, EKS Audit Logs , and Malware Protection PLans for GuardDuty
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

# This is enabling RDS, Lambda, and Runtime Monitoring protection plans for GuardDuty
resource "aws_guardduty_organization_configuration_feature" "delegated_admin" {
  provider = aws.secsvcs
  for_each = toset(local.gd_protection_plans)

  detector_id = local.detector_id
  name = each.value
  auto_enable = "ALL"
}



locals {
  gd_protection_plans = [ "RDS_LOGIN_EVENTS", "LAMBDA_NETWORK_LOGS" , "RUNTIME_MONITORING"]
}
