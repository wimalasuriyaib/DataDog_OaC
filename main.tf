terraform {
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.0"  # Specify the appropriate version
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key  # Ensure these variables are set
  app_key = var.datadog_app_key
}

# API Monitor for google.com
resource "datadog_synthetics_test" "google_api_monitor" {
  type   = "api"
  name   = "Google API Monitor"
  status = "live"  # Required argument

  request {
    method  = "GET"
    url     = "https://www.google.com"
    headers = {
      "Content-Type" = "application/json"
    }
  }

  locations = ["aws:us-east-1"]  # Specify the location for the test

  options {
    min_failure_duration = 60
    min_location_failed  = 1
    tick_every           = 300  # Frequency of the checks in seconds
  }
}

# Browser Monitor for google.com
resource "datadog_synthetics_test" "google_browser_monitor" {
  type   = "browser"
  name   = "Google Browser Monitor"
  status = "live"  # Required argument

  request {
    method  = "GET"
    url     = "https://www.google.com"
    body    = ""
  }

  locations = ["aws:us-east-1"]  # Specify the location for the test

  options {
    min_failure_duration = 60
    tick_every           = 300  # Frequency of the checks in seconds
  }
}

# Output the IDs of the created monitors
output "api_monitor_id" {
  value = datadog_synthetics_test.google_api_monitor.id
}

output "browser_monitor_id" {
  value = datadog_synthetics_test.google_browser_monitor.id
}

variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
}

variable "datadog_app_key" {
  description = "Datadog Application Key"
  type        = string
}
