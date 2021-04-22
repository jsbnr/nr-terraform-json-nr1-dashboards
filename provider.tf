# Configure the terraform and New Relic provider versions
# More details: https://www.terraform.io/docs/configuration/provider-requirements.html
terraform {
  required_version = "~> 0.14.3"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.21.0"
    }
  }
}


# Configure the New Relic provider with your API key details
# More details: https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/guides/getting_started

provider "newrelic" {
  #account_id = 0                          # Your New Relic account ID provided by env var NEW_RELIC_ACCOUNT_ID
  #api_key = "NRAK-xxx"   # Usually prefixed with 'NRAK' proved by env var NEW_RELIC_API_KEY
  region = "US"                           # Valid regions are US and EU provided by NEW_RELIC_REGION
}
