terraform {
  required_providers {
    opsgenie = {
      source = "opsgenie/opsgenie"
      version = "0.6.27"
    }
  }
}

provider "opsgenie" {
    api_key = var.opsgenie_api_key
}