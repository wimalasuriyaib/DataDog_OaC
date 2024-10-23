terraform {
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.0"  # Ensure this matches the latest documentation
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

# API Monitor for google.com
resource "datadog_synthetics_test" "google_api_monitor" {
  type   = "api"
  name   = "Google API Monitor"
  status = "live"

  request {
    method  = "GET"
    url     = "https://www.google.com"
    headers = {
      "Content-Type" = "application/json"
    }
  }

  locations = ["aws:us-east-1"]

  options {
    tick_every           = 300   # Check every 5 minutes
    min_failure_duration = 60    # Minimum duration (in seconds) before failing the test
    min_location_failed  = 1      # At least one location must fail for the test to be considered a failure
  }

  tags = ["environment:production"] # Optional: Add tags for better organization
}

# Define variables for API and App keys
variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
}

variable "datadog_app_key" {
  description = "Datadog Application Key"
  type        = string
}
