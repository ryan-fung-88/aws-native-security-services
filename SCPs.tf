## Option 1
module "SCPs" {
  source = "./modules/AWS-SCPs"

  organization_id = var.organization_id
  scps            = var.scps
  target_ou_id    = var.target_ou_id
}

#Option 2
module "SCPs" {
  source = "./modules/AWS-SCPs"

  organization_id = "o-1234567890" # Replace with your organization ID
  scps = {
    deny_root_user = {
      name        = "deny-root-user"
      description = "Prevents usage of the root user account"
      policy_content = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid      = "DenyRootUser"
            Effect   = "Deny"
            Action   = "*"
            Resource = "*"
            Condition = {
              StringLike = {
                "aws:PrincipalArn" = [
                  "arn:aws:iam::*:root"
                ]
              }
            }
          }
        ]
      })
      tags = {
        Purpose     = "Security"
        Environment = "All"
      }
    },
    deny_s3_public_access = {
      name        = "deny-s3-public-access"
      description = "Prevents public access to S3 buckets"
      policy_content = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid    = "DenyS3PublicAccessPolicy"
            Effect = "Deny"
            Action = [
              "s3:PutBucketPublicAccessBlock",
              "s3:DeletePublicAccessBlock"
            ]
            Resource = "*"
            Condition = {
              StringNotEquals = {
                "s3:PublicAccessBlockConfiguration" = [
                  "true"
                ]
              }
            }
          },
          {
            Sid    = "DenyS3PublicPolicy"
            Effect = "Deny"
            Action = [
              "s3:PutBucketPolicy"
            ]
            Resource = "*"
            Condition = {
              StringLike = {
                "s3:PolicyStatus" = [
                  "Public"
                ]
              }
            }
          }
        ]
      })
      tags = {
        Purpose     = "Security"
        Environment = "All"
      }
    }
  }

  target_ou_id = "ou-1234567890" # Replace with your target OU ID
}

