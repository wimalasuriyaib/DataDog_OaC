provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

# API Monitor for google.com
resource "datadog_synthetics_test" "google_api_monitor" {
  type = "api"

  request {
    method  = "GET"
    url     = "https://www.google.com"
    headers = {
      "Content-Type" = "application/json"
    }
  }

  locations = ["aws:us-east-1"]  # Specify the location for the test
  name      = "Google API Monitor"
  options {
    min_failure_duration = 60
    min_location_failed  = 1
    tick_every           = 300  # Frequency of the checks in seconds
  }
}

# Browser Monitor for google.com
resource "datadog_synthetics_test" "google_browser_monitor" {
  type = "browser"

  request {
    url     = "https://www.google.com"
    method  = "GET"
    body    = ""
  }

  locations = ["aws:us-east-1"]  # Specify the location for the test
  name      = "Google Browser Monitor"
  options {
    min_failure_duration = 60
    tick_every           = 300  # Frequency of the checks in seconds
  }
}
