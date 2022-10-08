
resource "google_storage_bucket" "s8s_spark_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_spark_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_spark_sphs_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_spark_sphs_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_data_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_data_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_code_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_code_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_notebook_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_notebook_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_model_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_model_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_metrics_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_metrics_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_bundle_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_bundle_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_vai_pipeline_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_pipeline_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/

resource "time_sleep" "sleep_after_bucket_creation" {
  create_duration = "60s"
  depends_on = [
    google_storage_bucket.s8s_data_bucket_creation,
    google_storage_bucket.s8s_code_bucket_creation,
    google_storage_bucket.s8s_notebook_bucket_creation,
    google_storage_bucket.s8s_spark_sphs_bucket_creation,
    google_storage_bucket.s8s_spark_bucket_creation,
    google_storage_bucket.s8s_model_bucket_creation,
    google_storage_bucket.s8s_metrics_bucket_creation,
    google_storage_bucket.s8s_vai_pipeline_bucket_creation,
    google_storage_bucket.s8s_bundle_bucket_creation
  ]
}


/******************************************
11. Copy of datasets, scripts and notebooks to buckets
 ******************************************/

resource "google_storage_bucket_object" "datasets_upload_to_gcs" {
  for_each = fileset("../01-datasets/", "*")
  source = "../01-datasets/${each.value}"
  name = "${each.value}"
  bucket = "${local.s8s_data_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation
  ]
}

resource "google_storage_bucket_object" "pyspark_scripts_dir_upload_to_gcs" {
  for_each = fileset("../02-scripts/", "*")
  source = "../02-scripts/${each.value}"
  name = "${each.value}"
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation
  ]
}

resource "google_storage_bucket_object" "pyspark_scripts_upload_to_gcs" {
  for_each = fileset("../02-scripts/pyspark/", "*")
  source = "../02-scripts/pyspark/${each.value}"
  name = "pyspark/${each.value}"
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    google_storage_bucket_object.pyspark_scripts_dir_upload_to_gcs
  ]
}

resource "google_storage_bucket_object" "notebooks_dir_create_in_gcs" {
  for_each = fileset("../03-notebooks/", "*")
  source = "../03-notebooks/${each.value}"
  name = "03-notebooks/${each.value}"
  bucket = "${local.s8s_notebook_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation
  ]
}

resource "google_storage_bucket_object" "notebooks_pyspark_upload_to_gcs" {
  for_each = fileset("../03-notebooks/pyspark/", "*")
  source = "../03-notebooks/pyspark/${each.value}"
  name = "pyspark/${each.value}"
  bucket = "${local.s8s_notebook_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    google_storage_bucket_object.notebooks_dir_create_in_gcs,
    null_resource.preprocessing_notebook_customization,
    null_resource.training_notebook_customization,
    null_resource.hpt_notebook_customization,
    null_resource.scoring_notebook_customization
  ]
}

resource "google_storage_bucket_object" "notebooks_vai_pipelines_upload_to_gcs" {
  for_each = fileset("../03-notebooks/vai-pipelines/", "*")
  source = "../03-notebooks/vai-pipelines/${each.value}"
  name = "vai-pipelines/${each.value}"
  bucket = "${local.s8s_notebook_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    google_storage_bucket_object.notebooks_dir_create_in_gcs,
    null_resource.vai_pipeline_notebook_customization
  ]
}

resource "google_storage_bucket_object" "bash_dir_create_in_gcs" {
  for_each = fileset("../02-scripts/", "*")
  source = "../02-scripts/${each.value}"
  name = "${each.value}"
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,    
    null_resource.umnbs_post_startup_bash_creation,
    null_resource.mnbs_post_startup_bash_creation
  ]
}

resource "google_storage_bucket_object" "bash_scripts_upload_to_gcs" {
  for_each = fileset("../02-scripts/bash/", "*")
  source = "../02-scripts/bash/${each.value}"
  name = "bash/${each.value}"
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    google_storage_bucket_object.bash_dir_create_in_gcs,
    null_resource.umnbs_post_startup_bash_creation,
    null_resource.mnbs_post_startup_bash_creation
  ]
}

resource "google_storage_bucket_object" "airflow_scripts_upload_to_gcs" {
  name   = "airflow/pipeline.py"
  source = "../02-scripts/airflow/pipeline.py"
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation
  ]
}

# Substituted version of pipeline JSON
resource "google_storage_bucket_object" "vai_pipeline_json_upload_to_gcs" {
  name   = "templates/customer_churn_vai_pipeline_template.json"
  source = "../05-pipelines/customer_churn_vai_pipeline_template.json"
  bucket = "${local.s8s_pipeline_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    null_resource.vai_pipeline_customization
  ]
}

resource "google_storage_bucket_object" "gcf_scripts_upload_to_gcs" {
  for_each = fileset("../02-scripts/cloud-functions/", "*")
  source = "../02-scripts/cloud-functions/${each.value}"
  name = "cloud-functions/${each.value}"
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation
  ]
}

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/

resource "time_sleep" "sleep_after_network_and_storage_steps" {
  create_duration = "120s"
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation,
      time_sleep.sleep_after_bucket_creation,
      google_storage_bucket_object.notebooks_vai_pipelines_upload_to_gcs,
      google_storage_bucket_object.notebooks_pyspark_upload_to_gcs,
      google_storage_bucket_object.pyspark_scripts_upload_to_gcs,
      google_storage_bucket_object.bash_scripts_upload_to_gcs,
      google_storage_bucket_object.airflow_scripts_upload_to_gcs,
      google_storage_bucket_object.vai_pipeline_json_upload_to_gcs,
      google_storage_bucket_object.gcf_scripts_upload_to_gcs
  ]
}
