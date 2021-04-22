terraform {
  required_version = "~> 0.14.3"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.21.0"
    }
  }
}