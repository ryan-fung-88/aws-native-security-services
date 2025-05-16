resource "aws_config_organization_managed_rule" "aws_managed_config_rules" {
  depends_on = [aws_organizations_organization.org]

  for_each        = local.aws_managed_config_rules
  name            = each.key
  rule_identifier = each.value.rule_identifier
}

resource "aws_config_organization_managed_rule" "aws_managed_config_rules_with_parameters" {
  depends_on = [aws_organizations_organization.org]

  for_each        = local.aws_managed_config_rules_with_parameters
  name            = each.key
  rule_identifier = each.value.rule_identifier
  input_parameters = each.value.input_parameters
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
      rule_identifier = "VPC_DEFAULT_SECURITY_GROUP_CLOSED"
    },
    cloudtrail_log_file_validation = {
      rule_identifier = "CLOUD_TRAIL_LOG_FILE_VALIDATION_ENABLED"
    },
    acm_expiration_check = {
      rule_identifier = "ACM_CERTIFICATE_EXPIRATION_CHECK"
    },
    secrets_rotation_enabled = {
      rule_identifier = "SECRETSMANAGER_ROTATION_ENABLED_CHECK"
    },
    kms_rotation_enabled = {
      rule_identifier = "CMK_BACKING_KEY_ROTATION_ENABLED"
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
      rule_identifier = "NACL_NO_UNRESTRICTED_SSH_RDP"
    }
  }

  aws_managed_config_rules_with_parameters ={
     iam_credential_expiration = {
      rule_identifier = "IAM_USER_UNUSED_CREDENTIALS_CHECK"
      input_parameters = jsonencode({
        "maxCredentialUsageAge" = 90
      })
    }
  }
}