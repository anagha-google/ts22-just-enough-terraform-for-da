/******************************************
18. Configure Cloud Scheduler to run the function
******************************************/

resource "google_cloud_scheduler_job" "schedule_vai_pipeline" {
  name             = "customer_churn_model_training_batch"
  description      = "Customer Churn One-time Model Training Vertex AI Pipeline"
  schedule         = "0 9 * * 1"
  time_zone        = local.cloud_scheduler_timezone
  attempt_deadline = "320s"
  region           = local.location

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions2_function.deploy_gcf_vai_pipeline_trigger.service_config[0].uri
    body        = base64encode("{\"foo\":\"bar\"}")
    oidc_token {
      service_account_email = local.umsa_fqn
    }
  }

  depends_on = [
    module.administrator_role_grants,
    time_sleep.sleep_after_network_and_storage_steps,
    google_storage_bucket_object.gcf_scripts_upload_to_gcs,
    google_cloudfunctions2_function.deploy_gcf_vai_pipeline_trigger
  ]
}
