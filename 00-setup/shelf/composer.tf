
/********************************************************
14. Create Composer Environment
********************************************************/

resource "google_composer_environment" "cloud_composer_env_creation" {
  name   = "${local.project_id}-cc2"
  region = local.location
  provider = google-beta
  project = local.project_id
  config {
    software_config {
      image_version = local.CLOUD_COMPOSER2_IMG_VERSION 
      env_variables = {
        AIRFLOW_VAR_PROJECT_ID = "${local.project_id}"
        AIRFLOW_VAR_PROJECT_NBR = "${local.project_nbr}"
        AIRFLOW_VAR_REGION = "${local.location}"
        AIRFLOW_VAR_SUBNET = "${local.spark_subnet_nm}"
        AIRFLOW_VAR_PHS_SERVER = "${local.s8s_spark_sphs_nm}"
        AIRFLOW_VAR_CONTAINER_IMAGE_URI = "gcr.io/${local.project_id}/customer_churn_image:${local.SPARK_CONTAINER_IMG_TAG}"
        AIRFLOW_VAR_BQ_CONNECTOR_JAR_URI = "${local.bq_connector_jar_gcs_uri}"
        AIRFLOW_VAR_DISPLAY_PRINT_STATEMENTS = "True"
        AIRFLOW_VAR_BQ_DATASET = "${local.bq_datamart_ds}"
        AIRFLOW_VAR_UMSA_FQN = "${local.umsa_fqn}"
      }
    }

    node_config {
      network    = local.vpc_nm
      subnetwork = local.spark_subnet_nm
      service_account = local.umsa_fqn
    }
  }

  depends_on = [
        module.administrator_role_grants,
        time_sleep.sleep_after_network_and_storage_steps,
        google_dataproc_cluster.sphs_creation  
  ] 

  timeouts {
    create = "75m"
  } 
}

output "CLOUD_COMPOSER_DAG_BUCKET" {
  value = google_composer_environment.cloud_composer_env_creation.config.0.dag_gcs_prefix
}

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/


resource "time_sleep" "sleep_after_composer_creation" {
  create_duration = "180s"
  depends_on = [
      google_composer_environment.cloud_composer_env_creation
  ]
}


/*******************************************
15. Upload Airflow DAG to Composer DAG bucket
******************************************/
# Remove the gs:// prefix and /dags suffix

resource "google_storage_bucket_object" "upload_cc2_dag_to_airflow_dag_bucket" {
  name   = "dags/pipeline.py"
  source = "../02-scripts/airflow/pipeline.py"  
  bucket = substr(substr(google_composer_environment.cloud_composer_env_creation.config.0.dag_gcs_prefix, 5, length(google_composer_environment.cloud_composer_env_creation.config.0.dag_gcs_prefix)), 0, (length(google_composer_environment.cloud_composer_env_creation.config.0.dag_gcs_prefix)-10))
  depends_on = [
    time_sleep.sleep_after_composer_creation
  ]
}