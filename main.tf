terraform {
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = ">= 3.46.0"  # Use the latest version
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
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

# Create a synthetic API check for the specified URL
resource "datadog_synthetics_test" "datadog_monitor_check" {
  name        = "Datadog Monitor Check"
  type        = "api"

  request {
    method = "GET"
    url    = "http://54.160.164.216/datadog_monitor.html"  # Updated URL
    headers = {
      "User-Agent" = "Terraform Synthetic Check"
    }
  }

  locations = ["aws:us-east-1"]  # Location for the check
  message   = "API Check for Datadog Monitor"
  tags      = ["env:production", "team:devops"]

  status = "live"  # Set the check to live

  options {
    tick_every = 60   # Frequency of the check in seconds
    timeout    = 10    # Timeout for the check in seconds
  }
}
