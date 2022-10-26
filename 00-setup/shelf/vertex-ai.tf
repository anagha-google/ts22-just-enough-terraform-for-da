
/******************************************************************
Vertex AI Workbench - User Managed Notebook Server Creation
******************************************************************/

resource "google_notebooks_instance" "create_umnb_server" {
  count = var.provision_vertex_ai_bool? 1 : 0
  project  = local.project_id 
  name = local.umnb_server_nm
  location = local.zone
  machine_type = "e2-medium"

  service_account = local.umsa_fqn
  network = "projects/${local.project_id}/global/networks/${local.vpc_nm}"
  subnet = "projects/${local.project_id}/regions/${local.location}/subnetworks/${local.subnet_nm}"
  post_startup_script = "gs://${local.code_bucket}/bash/umnbs-exec-post-startup.sh" 

  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "common-cpu"
  }
  depends_on = [
    time_sleep.sleep_after_network_and_storage_steps,
    time_sleep.sleep_after_script_custmomization
  ]  
}

/******************************************************************
Vertex AI Workbench - Managed Notebook Server Creation
******************************************************************/

resource "google_notebooks_runtime" "create_mnb_server" {
  count = var.provision_vertex_ai_bool? 1 : 0
  project              = local.project_id
  provider             = google-beta
  name                 = local.mnb_server_nm
  location             = local.location

  access_config {
    access_type        = "SERVICE_ACCOUNT"
    runtime_owner      = local.umsa_fqn
  }

  software_config {
    post_startup_script = "gs://${local.code_bucket}/bash/mnbs-exec-post-startup.sh"
    post_startup_script_behavior = "DOWNLOAD_AND_RUN_EVERY_START"
  }

  virtual_machine {
    virtual_machine_config {
      machine_type     = local.mnb_server_machine_type
      network = "projects/${local.project_id}/global/networks/${local.vpc_nm}"
      subnet = "projects/${local.project_id}/regions/${local.location}/subnetworks/${local.subnet_nm}" 

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
    time_sleep.sleep_after_network_and_storage_steps,
    time_sleep.sleep_after_script_custmomization
  ]  
}


