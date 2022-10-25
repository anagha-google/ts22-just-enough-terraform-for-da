resource "google_storage_bucket" "create_spark_bucket" {
  project                           = local.project_id 
  name                              = local.spark_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      module.setup_foundations
  ]
}

resource "google_storage_bucket" "create_dataproc_bucket" {
  project                           = local.project_id 
  name                              = local.dataproc_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
    depends_on = [
      module.setup_foundations
  ]
}

resource "google_storage_bucket" "create_phs_bucket" {
  project                           = local.project_id 
  name                              = local.sphs_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
    depends_on = [
      module.setup_foundations
  ]
}

resource "google_storage_bucket" "create_data_bucket" {
  project                           = local.project_id 
  name                              = local.data_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
    depends_on = [
      module.setup_foundations
  ]
}

resource "google_storage_bucket" "create_code_bucket" {
  project                           = local.project_id 
  name                              = local.code_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
    depends_on = [
      module.setup_foundations
  ]
}

resource "google_storage_bucket" "create_notebook_bucket" {
  project                           = local.project_id 
  name                              = local.notebook_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
    depends_on = [
      module.setup_foundations
  ]
}


/*******************************************
Introduce sleep to minimize errors from
dependencies having not completed
********************************************/

resource  "time_sleep" "sleep_after_creating_buckets" {
  create_duration = "60s"
  depends_on = [
    google_storage_bucket.create_data_bucket,
    google_storage_bucket.create_code_bucket,
    google_storage_bucket.create_notebook_bucket,
    google_storage_bucket.create_phs_bucket,
    google_storage_bucket.create_spark_bucket,
    google_storage_bucket.create_dataproc_bucket
  ]
}