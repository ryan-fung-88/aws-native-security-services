resource "aws_organizations_delegated_administrator" "iam_access_analyzer" {
  count = data.current_account_id == "" ? 1: 0
  account_id        = data.current_account_id # DELEGATED ADMIN ACCOUNT ID
  service_principal = "access-analyzer.amazonaws.com"
}

resource "aws_accessanalyzer_analyzer" "iam_access_analyzer_org_external_access" {
  analyzer_name = "TGRC-IAM-Access_Analyzer_External_Access"
  type          = "ORGANIZATION"

  tags = merge(
    {
      Name    = "IAM-Access_Analyzer_External_Access",
      AppName = "TGRC-IAM-Access_Analyzer_External_Access"
    },
  )
}

resource "aws_accessanalyzer_analyzer" "iam_access_analyzer_org_unused_access" {
  analyzer_name = "TGRC-IAM-Access_Analyzer_Unused_Access"
  type          = "ORGANIZATION_UNUSED_ACCESS"

  tags = merge(
    {
      Name    = "IAM-Access_Analyzer_Unused_Access",
      AppName = "TGRC-IAM-Access_Analyzer_Unused_Access"
    },
  )
}
