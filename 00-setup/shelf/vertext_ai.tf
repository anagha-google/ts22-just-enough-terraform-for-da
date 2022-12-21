
/******************************************************************
12c. Vertex AI Workbench - User Managed Notebook Server Creation
******************************************************************/

resource "google_storage_bucket_object" "bash_umnbs_script_upload_to_gcs" {
  count = var.install_vertextai? 1 : 0
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
  count = var.install_vertextai? 1 : 0
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
  count = var.install_vertextai? 1 : 0
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
  count = var.install_vertextai? 1 : 0
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



/****************************************************************************************************************
13b. Create custom container image for Vertex AI serving & push to Google Artifact Repository
****************************************************************************************************************/

resource "null_resource" "custom_container_image_creation_for_vertex_serving" {
    count = var.install_vertextai? 1 : 0
    provisioner "local-exec" {

        command = "/bin/bash ../02-scripts/bash/build-ml-serving-container-image.sh ${local.location} ${local.s8s_artifact_repository_nm}"
    }
    depends_on = [
        module.administrator_role_grants,
        module.vpc_creation,
        time_sleep.sleep_after_network_and_storage_steps,
        google_artifact_registry_repository.artifact_registry_creation
    ]  
}
