/******************************************
17. Deploy Google Cloud Function to execute VAI pipeline for model training
******************************************/

resource "google_storage_bucket" "create_gcf_source_bucket" {
  name                          = "${local.s8s_functions_bucket}"  
  location                      = local.location_multi
  uniform_bucket_level_access   = true
  depends_on = [
    module.administrator_role_grants,
    time_sleep.sleep_after_network_and_storage_steps
  ]
}

resource "google_storage_bucket_object" "upload_gcf_zip_file" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.create_gcf_source_bucket.name
  source = "../02-scripts/cloud-functions/function-source.zip"  
  depends_on = [
    google_storage_bucket.create_gcf_source_bucket
  ]
}

resource "google_cloudfunctions2_function" "deploy_gcf_vai_pipeline_trigger" {
  provider          = google-beta
  name              = "mlops-vai-pipeline-executor-func"
  location          = local.location
  description       = "GCF gen2 to execute a model training Vertex AI pipeline"
  project  = local.project_id
  build_config {
    runtime         = "python38"
    entry_point     = "process_request" 
    source {
      storage_source {
        bucket = google_storage_bucket.create_gcf_source_bucket.name
        object = google_storage_bucket_object.upload_gcf_zip_file.name
      }
    }
  }

  service_config {
    max_instance_count              = 1
    available_memory                = "256M"
    timeout_seconds                 = 60
    ingress_settings                = "ALLOW_ALL"
    all_traffic_on_latest_revision  = true
     
    environment_variables = {
        VAI_PIPELINE_JSON_TEMPLATE_GCS_FILE_FQN = "gs://s8s_pipeline_bucket-${local.project_nbr}/templates/customer_churn_vai_pipeline_template.json"
        VAI_PIPELINE_JSON_EXEC_DIR_URI = "gs://s8s_pipeline_bucket-${local.project_nbr}"
        GCP_LOCATION = local.location
        PROJECT_ID = local.project_id
        VAI_PIPELINE_ROOT_LOG_DIR = "gs://s8s_model_bucket-${local.project_nbr}/customer-churn-model/pipelines"
    }
    service_account_email = "s8s-lab-sa@${local.project_id}.iam.gserviceaccount.com"
  }

  depends_on = [
    module.administrator_role_grants,
    time_sleep.sleep_after_network_and_storage_steps,
    google_storage_bucket_object.gcf_scripts_upload_to_gcs
  ]
}

output "MODEL_TRAINING_VAI_PIPELINE_TRIGGER_FUNCTION_URI" { 
  value = google_cloudfunctions2_function.deploy_gcf_vai_pipeline_trigger.service_config[0].uri
}
