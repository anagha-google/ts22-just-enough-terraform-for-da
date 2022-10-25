resource "google_dataproc_metastore_service" "datalake_metastore_creation" {
  service_id = local.dpms_nm
  location   = local.location
  port       = 9080
  tier       = "DEVELOPER"
  network    = "projects/${local.project_id}/global/networks/${local.vpc_nm}"

  maintenance_window {
    hour_of_day = 2
    day_of_week = "SUNDAY"
  }

  hive_metastore_config {
    version = "3.1.2"
  }

  depends_on = [
    time_sleep.sleep_after_network_and_storage_steps
  ]
}
