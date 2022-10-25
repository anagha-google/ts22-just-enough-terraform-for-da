
/******************************************
10. Customize scripts and notebooks
 *****************************************/
 # Copy from templates and replace variables

resource "null_resource" "vai_pipeline_customization" {
    provisioner "local-exec" {
        command = "mkdir ../05-pipelines && cp ../04-templates/customer_churn_vai_pipeline_template.json ../05-pipelines/ && sed -i s/YOUR_PROJECT_NBR/${local.project_nbr}/g ../05-pipelines/customer_churn_vai_pipeline_template.json && sed -i s/YOUR_PROJECT_ID/${local.project_id}/g ../05-pipelines/customer_churn_vai_pipeline_template.json && sed -i s/YOUR_GCP_LOCATION/${local.location}/g ../05-pipelines/customer_churn_vai_pipeline_template.json "
        interpreter = ["bash", "-c"]
    }
}

