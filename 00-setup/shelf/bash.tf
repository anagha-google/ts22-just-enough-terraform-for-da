/******************************************
Run bash scripts
 *****************************************/

resource "null_resource" "run_bash_script" {
    provisioner "local-exec" {

        command = "/bin/bash ../02-scripts/bash/hello_world_bash_sample.sh ${local.admin_upn_fqn} ${local.location} gs://${local.spark_bucket}/dummy "
    }
    depends_on = [
        time_sleep.sleep_after_network_and_storage_steps
    ]
}

