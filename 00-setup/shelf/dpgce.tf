resource "google_dataproc_autoscaling_policy" "create_autoscale_policy" {
  policy_id = local.dpgce_autoscale_policy_nm
  location  = local.location

  worker_config {
    max_instances = 2
  }

  secondary_worker_config {
    min_instances = 0
    max_instances = 10
  }

  basic_algorithm {
    yarn_config {
      graceful_decommission_timeout = "30s"
      scale_up_factor   = 0.5
      scale_down_factor = 0.5
    }
  }
  depends_on = [
    time_sleep.sleep_after_network_and_storage_steps
  ]
}

resource "google_dataproc_cluster" "create_dpgce_cluster" {
  
  name     = "${local.dpgce_nm}"
  project  = var.project_id
  region   = local.location
  cluster_config {
    staging_bucket = local.spark_bucket
    temp_bucket = local.dataproc_bucket
    master_config {
      num_instances = 1
      machine_type  = "n1-standard-8"
      disk_config {
        boot_disk_size_gb = 1000
      }
    }
    
    preemptible_worker_config {
      num_instances = 0
    }

    endpoint_config {
        enable_http_port_access = "true"
    }

    autoscaling_config {
        policy_uri = "projects/${local.project_id}/locations/${local.location}/autoscalingPolicies/${local.dpgce_autoscale_policy_nm}"
    }

    # Override or set some custom properties
    software_config {
      image_version = "2.0-debian10"
      optional_components = [ "JUPYTER"]
    }

    initialization_action {
      script      = "gs://goog-dataproc-initialization-actions-${local.location}/connectors/connectors.sh"
      timeout_sec = 300
    }

    initialization_action {
      script      = "gs://goog-dataproc-initialization-actions-${local.location}/python/pip-install.sh"
      timeout_sec = 300
    }

    metastore_config {
        dataproc_metastore_service = "projects/${local.project_id}/locations/${local.location}/services/${local.dpms_nm}"
    }

    gce_cluster_config {
      zone        = "${local.zone}"
      subnetwork  = local.subnet_nm
      service_account = local.umsa_fqn
      service_account_scopes = [
        "cloud-platform"
      ]
      internal_ip_only = true
      shielded_instance_config {
        enable_secure_boot          = true
        enable_vtpm                 = true
        enable_integrity_monitoring = true
        }
     metadata = {
        "spark-bigquery-connector-version" : "0.26.0",
        "PIP_PACKAGES" : "pandas prophet plotly"
        }   
    }
  }
  depends_on = [
    time_sleep.sleep_after_network_and_storage_steps,
    google_dataproc_metastore_service.datalake_metastore_creation,
    google_dataproc_cluster.create_sphs,
    google_dataproc_autoscaling_policy.create_autoscale_policy
  ]  
}

resource "google_storage_bucket_object" "copy_notebook_to_dpgce_bucket" {
  for_each = {
    "../03-notebooks/pyspark/icecream-sales-forecasting.ipynb" : "notebooks/jupyter/icecream-sales-forecasting.ipynb"
  }
  name        = each.value
  source      = each.key
  bucket      = local.spark_bucket
  depends_on = [
      google_dataproc_cluster.create_dpgce_cluster, 
      time_sleep.sleep_after_bq_objects_creation
  ]
}

resource "time_sleep" "sleep_after_creating_dpgce" {
  create_duration = "120s"
  depends_on = [
   google_storage_bucket_object.copy_notebook_to_dpgce_bucket

  ]
}


