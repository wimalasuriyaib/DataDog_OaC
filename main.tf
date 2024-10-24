variable "datadog_api_key" {
  type = string
  description = "Datadog API key"
}

variable "datadog_app_key" {
  type = string
  description = "Datadog application key"
}

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
  region = "us-east-1"
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://us5.datadoghq.com/"
}

resource "datadog_synthetics_test" "test_google_uptime" {
  name     = "Cric Uptime Test"
  type     = "api"
  subtype  = "http"
  status   = "live"
  message  = "Notify when Google is down"
  locations = ["aws:eu-central-1", "aws:us-east-1", "aws:ap-southeast-1"]

  request_definition {
    method = "GET"
    url    = "http://www.cricinfo.com"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  options_list {
    tick_every = 300  # Run every 5 minutes

    retry {
      count    = 2
      interval = 300
    }

    monitor_options {
      renotify_interval = 120
    }
  }
}
