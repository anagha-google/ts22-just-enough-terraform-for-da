
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


/****************************************************************************************************************
13a. Create custom container image for Serverless Spark & push to Google Container Registry
****************************************************************************************************************/

resource "null_resource" "custom_container_image_creation_for_s8s" {
    provisioner "local-exec" {

        command = "/bin/bash ../02-scripts/bash/build-container-image.sh ${local.SPARK_CONTAINER_IMG_TAG} ${local.bq_connector_jar_gcs_uri} ${local.location}"
    }
    depends_on = [
        module.administrator_role_grants,
        module.vpc_creation,
        time_sleep.sleep_after_network_and_storage_steps,
        google_artifact_registry_repository.artifact_registry_creation
    ]  
}
