
/******************************************
12a. PHS creation
******************************************/

resource "google_dataproc_cluster" "sphs_creation" {
  project  = local.project_id 
  provider = google-beta
  name     = local.s8s_spark_sphs_nm
  region   = local.location

  cluster_config {
    
    endpoint_config {
        enable_http_port_access = true
    }

    staging_bucket = local.s8s_spark_bucket
    
    # Override or set some custom properties
    software_config {
      image_version = "2.0"
      override_properties = {
        "dataproc:dataproc.allow.zero.workers"=true
        "dataproc:job.history.to-gcs.enabled"=true
        "spark:spark.history.fs.logDirectory"="${local.s8s_spark_sphs_bucket_fqn}/*/spark-job-history"
        "mapred:mapreduce.jobhistory.read-only.dir-pattern"="${local.s8s_spark_sphs_bucket_fqn}/*/mapreduce-job-history/done"
      }      
    }
    gce_cluster_config {
      subnetwork =  "projects/${local.project_id}/regions/${local.location}/subnetworks/${local.spark_subnet_nm}" 
      service_account = local.umsa_fqn
      service_account_scopes = [
        "cloud-platform"
      ]
    }
  }
  depends_on = [
    module.administrator_role_grants,
    module.vpc_creation,
    time_sleep.sleep_after_network_and_storage_steps
  ]  
}


/******************************************************************
12c. Vertex AI Workbench - User Managed Notebook Server Creation
******************************************************************/

resource "google_storage_bucket_object" "bash_umnbs_script_upload_to_gcs" {
  name   = "bash/umnbs-exec-post-startup.sh"
  source = "../02-scripts/bash/umnbs-exec-post-startup.sh"  
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    time_sleep.sleep_after_network_and_storage_steps,
    google_storage_bucket_object.bash_dir_create_in_gcs,
    null_resource.umnbs_post_startup_bash_creation,
    null_resource.mnbs_post_startup_bash_creation,
    google_storage_bucket_object.bash_scripts_upload_to_gcs
    
  ]
}

resource "google_notebooks_instance" "umnb_server_creation" {
  project  = local.project_id 
  name = local.umnb_server_nm
  location = local.zone
  machine_type = "e2-medium"

  service_account = local.umsa_fqn
  network = "projects/${local.project_id}/global/networks/s8s-vpc-${local.project_nbr}"
  subnet = "projects/${local.project_id}/regions/${local.location}/subnetworks/${local.spark_subnet_nm}"
  post_startup_script = "gs://${local.s8s_code_bucket}/bash/umnbs-exec-post-startup.sh" 

  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "common-cpu"
  }
  depends_on = [
    module.administrator_role_grants,
    module.vpc_creation,
    time_sleep.sleep_after_network_and_storage_steps,
    google_storage_bucket_object.bash_scripts_upload_to_gcs,
    google_storage_bucket_object.notebooks_vai_pipelines_upload_to_gcs,
    google_storage_bucket_object.bash_umnbs_script_upload_to_gcs
  ]  
}

/******************************************************************
12d. Vertex AI Workbench - Managed Notebook Server Creation
******************************************************************/

resource "google_storage_bucket_object" "bash_mnbs_script_upload_to_gcs" {
  name   = "bash/mnbs-exec-post-startup.sh"
  source = "../02-scripts/bash/mnbs-exec-post-startup.sh"  
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    time_sleep.sleep_after_network_and_storage_steps,
    google_storage_bucket_object.bash_dir_create_in_gcs,
    null_resource.umnbs_post_startup_bash_creation,
    null_resource.mnbs_post_startup_bash_creation,
    google_storage_bucket_object.bash_scripts_upload_to_gcs
    
  ]
}

resource "google_notebooks_runtime" "mnb_server_creation" {
  project              = local.project_id
  provider             = google-beta
  name                 = local.mnb_server_nm
  location             = local.location

  access_config {
    access_type        = "SERVICE_ACCOUNT"
    runtime_owner      = local.umsa_fqn
  }

  software_config {
    post_startup_script = "gs://${local.s8s_code_bucket}/bash/mnbs-exec-post-startup.sh"
    post_startup_script_behavior = "DOWNLOAD_AND_RUN_EVERY_START"
  }

  virtual_machine {
    virtual_machine_config {
      machine_type     = local.mnb_server_machine_type
      network = "projects/${local.project_id}/global/networks/s8s-vpc-${local.project_nbr}"
      subnet = "projects/${local.project_id}/regions/${local.location}/subnetworks/${local.spark_subnet_nm}" 

      data_disk {
        initialize_params {
          disk_size_gb = "100"
          disk_type    = "PD_STANDARD"
        }
      }
      container_images {
        repository = "gcr.io/deeplearning-platform-release/base-cpu"
        tag = "latest"
      }
    }
  }
  depends_on = [
    module.administrator_role_grants,
    module.vpc_creation,
    google_compute_global_address.reserved_ip_for_psa_creation,
    google_service_networking_connection.private_connection_with_service_networking,
    time_sleep.sleep_after_network_and_storage_steps,
    google_storage_bucket_object.bash_scripts_upload_to_gcs,
    google_storage_bucket_object.notebooks_pyspark_upload_to_gcs,
    google_storage_bucket_object.bash_mnbs_script_upload_to_gcs
  ]  
}

/********************************************************
12e. Artifact registry for Serverless Spark custom container images
********************************************************/

resource "google_artifact_registry_repository" "artifact_registry_creation" {
    location          = local.location
    repository_id     = local.s8s_artifact_repository_nm
    description       = "Artifact repository"
    format            = "DOCKER"
    depends_on = [
        module.administrator_role_grants,
        module.vpc_creation,
        time_sleep.sleep_after_network_and_storage_steps
    ]  
}


/******************************************
16. Create Dataproc Metastore
******************************************/
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
    module.administrator_role_grants,
    time_sleep.sleep_after_network_and_storage_steps,
    google_dataproc_cluster.sphs_creation   
  ]
}
