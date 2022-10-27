resource "null_resource" "customize_umnbs_post_startup_script" {
    provisioner "local-exec" {
        command = "cp ../04-templates/umnbs-exec-post-startup.sh ../02-scripts/bash/ && sed -i s/YOUR_PROJECT_NBR/${local.project_nbr}/g ../02-scripts/bash/umnbs-exec-post-startup.sh"
    }
    depends_on =[time_sleep.sleep_after_network_and_storage_steps]
}

resource "null_resource" "customize_mnbs_post_startup_script" {
    provisioner "local-exec" {
        command = "cp ../04-templates/mnbs-exec-post-startup.sh ../02-scripts/bash/ && sed -i s/YOUR_PROJECT_NBR/${local.project_nbr}/g ../02-scripts/bash/mnbs-exec-post-startup.sh"
    }
    depends_on =[time_sleep.sleep_after_network_and_storage_steps]
}

resource "google_storage_bucket_object" "upload_umnbs_post_startup_script_to_gcs" {
  name        = "bash/umnbs-exec-post-startup.sh"
  source      = "../02-scripts/bash/umnbs-exec-post-startup.sh"
  bucket      = "${local.code_bucket}"
  depends_on = [time_sleep.sleep_after_network_and_storage_steps, null_resource.customize_umnbs_post_startup_script]
}

resource "google_storage_bucket_object" "upload_mnbs_post_startup_script_to_gcs" {
  name        = "bash/mnbs-exec-post-startup.sh"
  source      = "../02-scripts/bash/mnbs-exec-post-startup.sh"
  bucket      = "${local.code_bucket}"
  depends_on = [time_sleep.sleep_after_network_and_storage_steps, null_resource.customize_mnbs_post_startup_script]
}

resource "time_sleep" "sleep_after_script_custmomization" {
  create_duration = "60s"
  depends_on = [
      google_storage_bucket_object.upload_mnbs_post_startup_script_to_gcs,
      google_storage_bucket_object.upload_umnbs_post_startup_script_to_gcs
  ]
}