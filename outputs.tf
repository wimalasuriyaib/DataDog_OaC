output "google_api_monitor_id" {
  value = datadog_synthetics_test.google_api_monitor.id
}

output "google_browser_monitor_id" {
  value = datadog_synthetics_test.google_browser_monitor.id
}
