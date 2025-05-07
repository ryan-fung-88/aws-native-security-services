## Option 1
module "aws_config" {
  source = "./modules/AWS-Config"

  config_recorder_name          = var.config_recorder_name
  recording_all_resource_types  = var.recording_all_resource_types
  include_global_resource_types = var.include_global_resource_types
  resource_types_to_record      = var.resource_types_to_record
  enable_config_recorder        = var.enable_config_recorder
  delivery_channel_name         = var.delivery_channel_name
  snapshot_delivery_frequency   = var.snapshot_delivery_frequency
  managed_rules                 = var.managed_rules
}

## Option 2
module "aws_config" {
  source = "./modules/AWS-Config"

  config_recorder_name          = "AWS-Config-Recorder"
  recording_all_resource_types  = true
  include_global_resource_types = true
  #resource_types_to_record = var.resource_types_to_record  // Optional, only if recording_all_resource_types is false
  enable_config_recorder      = true
  delivery_channel_name       = "AWS-Config-Delivery-Channel"
  snapshot_delivery_frequency = "One_Hour"
  managed_rules = {
    root_account_mfa = {
      identifier  = "ROOT_ACCOUNT_MFA_ENABLED"
      description = "Checks whether the root user of your AWS account requires multi-factor authentication for console sign-in."
    },
    restricted_ssh = {
      identifier  = "RESTRICTED_INCOMING_TRAFFIC"
      description = "Checks whether security groups that are in use disallow unrestricted incoming SSH traffic."
      parameters = jsonencode({
        blockedPort1 = "22"
      })
    },
    restricted_rdp = {
      identifier  = "RESTRICTED_INCOMING_TRAFFIC"
      description = "Checks whether security groups that are in use disallow unrestricted incoming RDP traffic."
      parameters = jsonencode({
        blockedPort1 = "3389"
      })
    },
  }
}


