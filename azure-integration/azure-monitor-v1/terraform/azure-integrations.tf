# OpsGenie Azure Integration Terraform
# REF: https://registry.terraform.io/providers/opsgenie/opsgenie/latest/docs/resources/api_integration

resource "opsgenie_api_integration" "test" {
  name = "Azure - Test"
  type = "Azure"
  owner_team_id                  = "${data.opsgenie_team.security_team.id}"
}
