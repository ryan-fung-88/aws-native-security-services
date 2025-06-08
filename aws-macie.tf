locals {
    aws_account_ids = {
        "email1" = "123456789012"
        "email2" = "234567890123"
        # Add more accounts as needed
    }
}

# This needs to be deployed at the Master Payer Account Level I believe
resource "aws_macie2_organization_admin_account" "macie_delegated_admin" {
  admin_account_id = "ID of the Delegated Admin Account"
}


# This is to be deployed at the delegated admin level
resource "aws_macie2_account" "delegated_admin_macie_account" {
    #count = account_id == Delegated Admin Account ID ? 1 : 0
    finding_publishing_frequency = "FIFTEEN_MINUTES"
    status                       = "ENABLED"
}

resource "aws_macie2_organization_configuration" "org_config" {
  #count = account_id == Delegated Admin Account ID ? 1 : 0
  auto_enable = true
}

resource "aws_macie2_member" "macie_account_invites" {
    #count = account_id == Delegated Admin Account ID ? 1 : 0
    for_each = local.aws_account_ids

    account_id = each.key
    email = each.value
    invite = true

    depends_on = [aws_macie2_account.mpa_macie_account]
}

# this needs to be deployed at each memeber account level
resource "aws_macie2_account" "member_macie_account" {
    finding_publishing_frequency = "FIFTEEN_MINUTES"
    status                       = "ENABLED"
}

resource "aws_macie2_invitation_accepter" "member" {
  administrator_account_id = "Delegated Admin Account ID"
}




