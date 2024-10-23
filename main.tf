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
    tick_every           = 300
    min_failure_duration = 60
    min_location_failed  = 1
  }
}

# Browser Monitor for google.com
resource "datadog_synthetics_test" "google_browser_monitor" {
  type   = "browser"
  name   = "Google Browser Monitor"
  status = "live"

  request {
    method = "GET"
    url    = "https://www.google.com"
  }

  locations = ["aws:us-east-1"]

  options {
    tick_every           = 300
    min_failure_duration = 60
  }
}

# Output the IDs of the created monitors
output "google_api_monitor_id" {
  value = datadog_synthetics_test.google_api_monitor.id
}

output "google_browser_monitor_id" {
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
