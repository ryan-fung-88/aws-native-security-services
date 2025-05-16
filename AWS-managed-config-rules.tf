resource "aws_config_organization_managed_rule" "aws_managed_config_rules" {
  depends_on = [aws_organizations_organization.org]

  for_each        = local.aws_managed_config_rules
  name            = each.key
  rule_identifier = each.value.rule_identifier
}

locals {
  aws_managed_config_rules = {
    cloudtrail_enabled = {
      rule_identifier = "CLOUD_TRAIL_ENABLED"
    },
    guardduty_enabled = {
      rule_identifier = "GUARDDUTY_ENABLED_CENTRALIZED"
    },
    securityhub_enabled = {
      rule_identifier = "SECURITYHUB_ENABLED"
    },
    vpc_flow_logs_enabled = {
      rule_identifier = "VPC_FLOW_LOGS_ENABLED"
    },
    s3_public_access_check = {
      rule_identifier = "S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED"
    },
    default_security_group_check = {
      rule_identifier = "VPC_DEFAULT_SECURITY_GROUPS_CHECK"
    },
    cloudtrail_log_file_validation = {
      rule_identifier = "CLOUD_TRAIL_LOG_FILE_VALIDATION_ENABLED"
    },
    acm_expiration_check = {
      rule_identifier = "ACM_CERTIFICATE_EXPIRATION_CHECK"
    },
    secrets_rotation_enabled = {
      rule_identifier = "SECRETS_MANAGER_ROTATION_ENABLED"
    },
    kms_rotation_enabled = {
      rule_identifier = "CMK_BACKING_KEY_ROTATION_ENABLED"
    },
    iam_credential_expiration = {
      rule_identifier = "IAM_USER_CREDENTIALS_EXPIRATION_CHECK"
    },
    ec2_instance_profile_check = {
      rule_identifier = "EC2_INSTANCE_PROFILE_ATTACHED"
    },
    iam_user_policy_check = {
      rule_identifier = "IAM_USER_NO_POLICIES_CHECK"
    },
    s3_versioning_check = {
      rule_identifier = "S3_BUCKET_VERSIONING_ENABLED"
    },
    nacl_restrict_ssh_rdp = {
      rule_identifier = "NACL_NO_UNRESTRICT_SSH_RDP"
    }
  }
}