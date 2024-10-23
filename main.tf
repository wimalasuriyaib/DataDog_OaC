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
  api_key = jsondecode(data.aws_secretsmanager_secret_version.example_secret.secret_string)["api_key"]
  app_key = jsondecode(data.aws_secretsmanager_secret_version.example_secret.secret_string)["app_key"]
  api_url = "https://us5.datadoghq.com/"
}

resource "datadog_synthetics_test" "test_google_uptime" {
  name     = "Google Uptime Test"
  type     = "api"
  subtype  = "http"
  status   = "live"
  message  = "Notify when Google is down"
  locations = ["aws:eu-central-1", "aws:us-east-1", "aws:ap-southeast-1"]

  request_definition {
    method = "GET"
    url    = "https://www.google.com"
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
