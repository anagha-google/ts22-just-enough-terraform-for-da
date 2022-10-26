
/******************************************
Create directories in buckets
 ******************************************/

resource "google_storage_bucket_object" "create_sub_directories_for_scripts_in_gcs" {
  for_each = fileset("../02-scripts/", "*")
  source = "../02-scripts/${each.value}"
  name = "${each.value}"
  bucket = "${local.code_bucket}"
  depends_on = [
    time_sleep.sleep_after_creating_buckets
  ]
}

resource "google_storage_bucket_object" "create_sub_directories_for_notebooks_in_gcs" {
  for_each = fileset("../03-notebooks/", "*")
  source = "../03-notebooks/${each.value}"
  name = "03-notebooks/${each.value}"
  bucket = "${local.notebook_bucket}"
  depends_on = [
    time_sleep.sleep_after_creating_buckets
  ]
}

/******************************************
Upload data to the data bucket
 ******************************************/

resource "google_storage_bucket_object" "upload_data_to_gcs" {
  for_each = fileset("../01-datasets/", "*")
  source = "../01-datasets/${each.value}"
  name = "${each.value}"
  bucket = "${local.data_bucket}"
  depends_on = [
    time_sleep.sleep_after_creating_buckets
  ]
}

/******************************************
Upload pyspark scripts to the code bucket
 ******************************************/

resource "google_storage_bucket_object" "upload_pyspark_scripts_to_gcs" {
  for_each = fileset("../02-scripts/pyspark/", "*")
  source = "../02-scripts/pyspark/${each.value}"
  name = "pyspark/${each.value}"
  bucket = "${local.code_bucket}"
  depends_on = [
    time_sleep.sleep_after_creating_buckets,
    google_storage_bucket_object.create_sub_directories_for_scripts_in_gcs
  ]
}

/******************************************
Upload pyspark notebooks to the notebook bucket
 ******************************************/

resource "google_storage_bucket_object" "upload_pyspark_notebooks_to_gcs" {
  for_each = fileset("../03-notebooks/pyspark/", "*")
  source = "../03-notebooks/pyspark/${each.value}"
  name = "pyspark/${each.value}"
  bucket = "${local.notebook_bucket}"
  depends_on = [
    time_sleep.sleep_after_creating_buckets,
    google_storage_bucket_object.create_sub_directories_for_notebooks_in_gcs
  ]
}

/******************************************
Upload python notebooks to the notebook bucket
 ******************************************/

resource "google_storage_bucket_object" "upload_python_notebooks_to_gcs" {
  for_each = fileset("../03-notebooks/python/", "*")
  source = "../03-notebooks/python/${each.value}"
  name = "python/${each.value}"
  bucket = "${local.notebook_bucket}"
  depends_on = [
    time_sleep.sleep_after_creating_buckets,
    google_storage_bucket_object.create_sub_directories_for_notebooks_in_gcs
  ]
}

/******************************************
Upload bash scripts to the code bucket
 ******************************************/

resource "google_storage_bucket_object" "upload_bash_scripts_to_gcs" {
  for_each = fileset("../02-scripts/bash/", "*")
  source = "../02-scripts/bash/${each.value}"
  name = "bash/${each.value}"
  bucket = "${local.code_bucket}"
  depends_on = [
    time_sleep.sleep_after_creating_buckets,
    google_storage_bucket_object.create_sub_directories_for_scripts_in_gcs
  ]
}

/******************************************
Upload airflow DAG to the scripts bucket
 ******************************************/

resource "google_storage_bucket_object" "upload_airflow_scripts_to_gcs" {
  name   = "airflow/pipeline.py"
  source = "../02-scripts/airflow/pipeline.py"
  bucket = "${local.code_bucket}"
  depends_on = [
    time_sleep.sleep_after_creating_buckets,
    google_storage_bucket_object.create_sub_directories_for_scripts_in_gcs
  ]
}


/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/

resource "time_sleep" "sleep_after_network_and_storage_steps" {
  create_duration = "120s"
  depends_on = [
      time_sleep.sleep_after_creating_network_services,
      time_sleep.sleep_after_creating_buckets,
      google_storage_bucket_object.upload_pyspark_scripts_to_gcs,
      google_storage_bucket_object.upload_bash_scripts_to_gcs,
      google_storage_bucket_object.upload_airflow_scripts_to_gcs,
      google_storage_bucket_object.upload_pyspark_notebooks_to_gcs,
      google_storage_bucket_object.upload_python_notebooks_to_gcs
  ]
}
