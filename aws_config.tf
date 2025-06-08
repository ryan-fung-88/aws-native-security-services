# Option 1
# module "aws_config" {
#   source = "./modules/AWS-Config"

#   config_recorder_name          = var.config_recorder_name
#   config_role                   = var.config_role
#   recording_all_resource_types  = var.recording_all_resource_types
#   include_global_resource_types = var.include_global_resource_types
#   resource_types_to_record      = var.resource_types_to_record
#   enable_config_recorder        = var.enable_config_recorder

#   include_config_aggregator = var.include_config_aggregator
#   config_aggregator_collection_account_id = var.config_aggregator_collection_account_id
#   config_aggregation_collection_region     = var.config_aggregation_collection_region
#   account_aggregator_name        = var.account_aggregator_name
#   config_aggregation_account_ids = var.config_aggregation_account_ids
#   config_aggregation_all_regions = var.config_aggregation_all_regions
#   config_aggregation_regions     = var.config_aggregation_regions

#   delivery_channel_name         = var.delivery_channel_name
#   s3_config_bucket              = var.s3_config_bucket
#   snapshot_delivery_frequency   = var.snapshot_delivery_frequency

#   managed_rules                 = var.managed_rules
# }

## Option 2
module "aws_config" {
  source = "./modules/AWS-Config"

  config_recorder_name          = "AWS-Config-Recorder"
  config_role                   = "arn:aws:iam::123456789012:role/aws_config_role"
  recording_all_resource_types  = true
  include_global_resource_types = true
  #resource_types_to_record = [ "AWS::IAM::User", "AWS::EC2::SecurityGroup" ]  # Specify the resource types you want to record
  enable_config_recorder = true

  include_config_aggregator               = true
  config_aggregator_collection_account_id = "123456789012"
  config_aggregation_collection_region    = "us-east-1"
  account_aggregator_name                 = "AWS-Config-Aggregator"
  config_aggregation_account_ids          = ["123456789012"] # Replace with the AWS account IDs you want to aggregate from
  config_aggregation_all_regions          = true
  #config_aggregation_regions = [ "us-east-1", "us-west-2" ]  # Example regions to aggregate from

  delivery_channel_name       = "AWS-Config-Delivery-Channel"
  s3_config_bucket            = "my-config-bucket"
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
    elb-logging-check = {
      identifier  = "ELB_LOGGING_ENABLED"
      description = "Checks if the Application Load Balancer and the Classic Load Balancer have logging enabled"
      parameters = jsonencode({
        s3BucketNames = "test-bucket"
      })
    },
  }
}


