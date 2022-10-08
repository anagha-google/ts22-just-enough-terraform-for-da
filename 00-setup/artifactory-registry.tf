
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

/****************************************************************************************************************
13b. Create custom container image for Vertex AI serving & push to Google Artifact Repository
****************************************************************************************************************/

resource "null_resource" "custom_container_image_creation_for_vertex_serving" {
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
