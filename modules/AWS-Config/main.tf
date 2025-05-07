resource "aws_config_configuration_recorder" "config_recorder" {
  name     = var.config_recorder_name
  role_arn = aws_iam_role.config_recorder.arn  # Replace with the centralized aws config role ARN

  recording_group {
    all_supported                 = var.recording_all_resource_types
    include_global_resource_types = var.include_global_resource_types

    dynamic "resource_types" {
      for_each = var.recording_all_resource_types ? [] : var.resource_types_to_record
      content {
        resource_types = resource_types.value
      }
    }
  }
}

resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = var.enable_config_recorder

  depends_on = [
    aws_config_delivery_channel.this,
    aws_config_configuration_recorder.config_recorder,
  ]
}

resource "aws_config_delivery_channel" "config_delivery_channel" {
  name           = var.delivery_channel_name
  s3_bucket_name = aws_s3_bucket.config_logs.id  # Replace with the S3 bucket used for centralized logging
  snapshot_delivery_properties {
    delivery_frequency = var.snapshot_delivery_frequency
  }

  depends_on = [
    aws_config_configuration_recorder.this,
    # S3 bucket must be created before the delivery channel
  ]

}

resource "aws_config_config_rule" "managed_rules" {
  for_each = var.managed_rules

  name        = each.key
  description = lookup(each.value, "description", "AWS Managed Config Rule - ${each.key}")

  source {
    owner             = "AWS"
    source_identifier = each.value.identifier
  }

  input_parameters = lookup(each.value, "parameters", null)

  depends_on = [aws_config_configuration_recorder.this]
}