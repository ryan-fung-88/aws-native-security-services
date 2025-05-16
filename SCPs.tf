// This SCP would prevent resources from being deployed if they dont have appropriate tags
data "aws_iam_policy_document" "deny_resources_without_required_tags" {
  statement {
    sid = "RequireResourceTags"
    effect = "Deny"

    actions = [ # add more actions as needed
      "ec2:RunInstances",
      "s3:CreateBucket"
    ]

    resources = [ # add more resources as needed
      "arn:aws:ec2:::*",
      "arn:aws:s3:::*"
    ]

    condition { # add more conditions as needed
      test = "ForAnyValue:StringNotEqualsIfExists"
      variable = "aws:ResourceTag/Environment"
      values = [ "*" ]
      }
     condition {
      test = "ForAnyValue:StringNotEqualsIfExists"
      variable = "aws:ResourceTag/Owner"
      values = [ "*" ]
      }
    }
  }

resource "aws_organizations_policy" "require_resource_tags" {
  name   = "Require Resource Tags"
  description = "Deny resources without required tags"
  type   = "SERVICE_CONTROL_POLICY" 
  content = data.aws_iam_policy_document.deny_resources_without_required_tags.json
}

// This SCP would prevent IAM roles and users from being created without a permission boundary
data "aws_iam_policy_document" "IAM_roles_users_require_permission_boundary" {
  statement {
    sid = "RequirePermissionBoundary"
    effect = "Deny"

    actions = [ 
      "iam:CreateRole",
      "iam:CreateUser"
    ]

    resources = [ 
      "arn:aws:iam:::*"
    ]

    condition { 
      test = "StringNotEqualsIfExists"
      variable = "iam:PermissionBoundary"
      values = [ "*" ] # insert the ARN of the permission boundary policy
      }
    }
  }
  
resource "aws_organizations_policy" "require_permission_boundary" {
  name   = "Require Permission Boundary"
  description = "Deny creation of IAM roles and users without permission boundary"
  type   = "SERVICE_CONTROL_POLICY" 
  content = data.aws_iam_policy_document.IAM_roles_users_require_permission_boundary.json
}


// This SCP would prevent deletion of KMS keys
data "aws_iam_policy_document" "deny_deletion_of_kms_keys" {
  statement {
    sid = "PreventKMSKeyDeletion"
    effect = "Deny"

    actions = [ 
      "kms:ScheduleKeyDeletion",
      "kms:DeleteAlias",
      "kms:DeleteImportedKeyMaterial"
    ]

    resources = [ 
      "arn:aws:kms:*:*:key/*"
    ]

    condition { 
      test = "ArnNotLike"
      variable = "aws:PrincipalArn"
      values = [ "*" ] # insert the ARN of the security principal
      }
    }
  }
  
resource "aws_organizations_policy" "deny_deletion_of_kms_keys" {
  name   = "Deny Deletion of KMS Keys"
  description = "Prevent deletion of KMS keys"
  type   = "SERVICE_CONTROL_POLICY" 
  content = data.aws_iam_policy_document.deny_deletion_of_kms_keys.json
}

// This SCP requries certain AMIs to be used
data "aws_iam_policy_document" "require_ami" {
  statement {
    sid = "RequireAMI"
    effect = "Deny"

    actions = [ 
      "ec2:RunInstances",
      "ec2:CreateLaunchTemplateVersion",
      "ec2:CreateFleet",
      "ec2:RunScheduledInstances"
    ]

    resources = [ 
      "arn:aws:ec2:::*"
    ]

    condition { 
      test = "StringNotEqualsIfExists"
      variable = "ec2:ImageId"
      values = [ "*" ] # insert the AMI IDs
      }
    }
  }
  
resource "aws_organizations_policy" "require_ami" {
  name   = "Require AMI"
  description = "Deny use of non-approved AMIs"
  type   = "SERVICE_CONTROL_POLICY" 
  content = data.aws_iam_policy_document.require_ami.json
}