
/******************************************
10. Customize scripts and notebooks
 *****************************************/
 # Copy from templates and replace variables

resource "null_resource" "umnbs_post_startup_bash_creation" {
    provisioner "local-exec" {
        command = "cp ../04-templates/umnbs-exec-post-startup.sh ../02-scripts/bash/ && sed -i s/PROJECT_NBR/${local.project_nbr}/g ../02-scripts/bash/umnbs-exec-post-startup.sh"
    }
}

resource "null_resource" "mnbs_post_startup_bash_creation" {
    provisioner "local-exec" {
        command = "cp ../04-templates/mnbs-exec-post-startup.sh ../02-scripts/bash/ && sed -i s/PROJECT_NBR/${local.project_nbr}/g ../02-scripts/bash/mnbs-exec-post-startup.sh"
    }
}

resource "null_resource" "preprocessing_notebook_customization" {
    provisioner "local-exec" {
        command = "cp ../04-templates/preprocessing.ipynb ../03-notebooks/pyspark/ && sed -i s/YOUR_PROJECT_NBR/${local.project_nbr}/g ../03-notebooks/pyspark/preprocessing.ipynb && sed -i s/YOUR_PROJECT_ID/${local.project_id}/g ../03-notebooks/pyspark/preprocessing.ipynb"
        interpreter = ["bash", "-c"]
    }
}

resource "null_resource" "training_notebook_customization" {
    provisioner "local-exec" {
        command = "cp ../04-templates/model_training.ipynb ../03-notebooks/pyspark/ && sed -i s/YOUR_PROJECT_NBR/${local.project_nbr}/g ../03-notebooks/pyspark/model_training.ipynb && sed -i s/YOUR_PROJECT_ID/${local.project_id}/g ../03-notebooks/pyspark/model_training.ipynb"
        interpreter = ["bash", "-c"]    
    }
}

resource "null_resource" "hpt_notebook_customization" {
    provisioner "local-exec" {
        command = "cp ../04-templates/hyperparameter_tuning.ipynb ../03-notebooks/pyspark/ && sed -i s/YOUR_PROJECT_NBR/${local.project_nbr}/g ../03-notebooks/pyspark/hyperparameter_tuning.ipynb && sed -i s/YOUR_PROJECT_ID/${local.project_id}/g ../03-notebooks/pyspark/hyperparameter_tuning.ipynb"
        interpreter = ["bash", "-c"]
    }
}

resource "null_resource" "scoring_notebook_customization" {
    provisioner "local-exec" {
        command = "cp ../04-templates/batch_scoring.ipynb ../03-notebooks/pyspark/ && sed -i s/YOUR_PROJECT_NBR/${local.project_nbr}/g ../03-notebooks/pyspark/batch_scoring.ipynb && sed -i s/YOUR_PROJECT_ID/${local.project_id}/g ../03-notebooks/pyspark/batch_scoring.ipynb"
        interpreter = ["bash", "-c"]
    }
}

resource "null_resource" "vai_pipeline_notebook_customization" {
    provisioner "local-exec" {
        command = "cp ../04-templates/customer_churn_training_pipeline.ipynb ../03-notebooks/vai-pipelines/ && sed -i s/YOUR_GCP_LOCATION/${local.location}/g ../03-notebooks/vai-pipelines/customer_churn_training_pipeline.ipynb && sed -i s/YOUR_SPARK_CONTAINER_IMAGE_TAG/${local.SPARK_CONTAINER_IMG_TAG}/g ../03-notebooks/vai-pipelines/customer_churn_training_pipeline.ipynb"
        interpreter = ["bash", "-c"]
    }
}

resource "null_resource" "vai_pipeline_customization" {
    provisioner "local-exec" {
        command = "mkdir ../05-pipelines && cp ../04-templates/customer_churn_vai_pipeline_template.json ../05-pipelines/ && sed -i s/YOUR_PROJECT_NBR/${local.project_nbr}/g ../05-pipelines/customer_churn_vai_pipeline_template.json && sed -i s/YOUR_PROJECT_ID/${local.project_id}/g ../05-pipelines/customer_churn_vai_pipeline_template.json && sed -i s/YOUR_GCP_LOCATION/${local.location}/g ../05-pipelines/customer_churn_vai_pipeline_template.json "
        interpreter = ["bash", "-c"]
    }
}

