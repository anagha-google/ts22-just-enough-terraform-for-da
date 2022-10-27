resource "google_composer_environment" "create_cloud_composer_env" {
  name   = "${local.project_id}-cc2"
  region = local.location
  provider = google-beta
  project = local.project_id
  config {
    software_config {
      image_version = local.CLOUD_COMPOSER2_IMG_VERSION 
      env_variables = {
        AIRFLOW_VAR_GCP_ACCOUNT_NAME = "${local.admin_upn_fqn}"
      }
    }

    node_config {
      network    = local.vpc_nm
      subnetwork = local.subnet_nm
      service_account = local.umsa_fqn
    }
  }

  depends_on = [
        time_sleep.sleep_after_network_and_storage_steps,
        time_sleep.sleep_after_creating_dpgce  
  ] 

  timeouts {
    create = "75m"
  } 
}

output "CLOUD_COMPOSER_DAG_BUCKET" {
  value = google_composer_environment.create_cloud_composer_env.config.0.dag_gcs_prefix
}

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/


resource "time_sleep" "sleep_after_creating_composer" {
  create_duration = "180s"
  depends_on = [
      google_composer_environment.create_cloud_composer_env
  ]
}


/*******************************************
Upload Airflow DAG to Composer DAG bucket
******************************************/

resource "google_storage_bucket_object" "upload_cc2_dag_to_airflow_dag_bucket" {
  name   = "dags/pipeline.py"
  source = "../02-scripts/airflow/pipeline.py"  
  bucket = substr(substr(google_composer_environment.create_cloud_composer_env.config.0.dag_gcs_prefix, 5, length(google_composer_environment.create_cloud_composer_env.config.0.dag_gcs_prefix)), 0, (length(google_composer_environment.create_cloud_composer_env.config.0.dag_gcs_prefix)-10))
  depends_on = [
    time_sleep.sleep_after_creating_composer
  ]
}
