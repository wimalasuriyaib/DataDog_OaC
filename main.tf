terraform {
  required_version = ">= 0.15.5"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 3.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Adjust the region as needed
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://us5.datadoghq.com/"
}

# Declare input variables for Datadog API and App keys
variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
}

variable "datadog_app_key" {
  description = "Datadog Application key"
  type        = string
}

data "aws_secretsmanager_secret_version" "example_secret" {
  secret_id = "your_secret_id_here"  # Replace with your actual secret ID
}

resource "datadog_synthetics_test" "test_uptime" {
  name     = "Synthetics Test"
  type     = "api"
  subtype  = "http"
  status   = "live"
  message  = "Notify on failure"
  locations = ["aws:eu-central-1", "aws:us-east-1", "aws:ap-southeast-1"]

  request_definition {
    method = "GET"
    url    = "http://54.160.164.216/datadog_monitor.html"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = 302  # Ensure this is a number
  }

  // Add any necessary configuration directly here, based on documentation
  // If you need to define retry behavior, consider moving it to assertion levels if applicable.
}
