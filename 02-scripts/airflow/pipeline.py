# ======================================================================================
# ABOUT
# This script orchestrates batch scoring 
# ======================================================================================

import os
from airflow.models import Variable
from datetime import datetime
from airflow import models
from airflow.providers.google.cloud.operators.dataproc import (DataprocCreateBatchOperator,DataprocGetBatchOperator)
from datetime import datetime
from airflow.utils.dates import days_ago
import string
import random 

# .......................................................
# Variables
# .......................................................

# {{
# a) General
randomizerCharLength = 10 
randomVal = ''.join(random.choices(string.digits, k = randomizerCharLength))
airflowDAGName= "customer-churn-prediction"
batchIDPrefix = f"{airflowDAGName}-edo-{randomVal}"
# +
# b) Capture from Airflow variables
region = models.Variable.get("region")
subnet=models.Variable.get("subnet")
phsServer=Variable.get("phs_server")
containerImageUri=Variable.get("container_image_uri")
bqDataset=Variable.get("bq_dataset")
umsaFQN=Variable.get("umsa_fqn")
bqConnectorJarUri=Variable.get("bq_connector_jar_uri")
# +
# c) For the Spark application
pipelineID = randomVal
projectID = models.Variable.get("project_id")
projectNbr = models.Variable.get("project_nbr")
displayPrintStatements=Variable.get("display_print_statements")
# +
# d) Arguments array
batchScoringArguments = [f"--pipelineID={pipelineID}", \
        f"--projectID={projectID}", \
        f"--projectNbr={projectNbr}", \
        f"--displayPrintStatements={displayPrintStatements}" ]
# +
# e) PySpark script to execute
scoringScript= "gs://s8s_code_bucket-"+projectNbr+"/pyspark/batch_scoring.py"
commonUtilsScript= "gs://s8s_code_bucket-"+projectNbr+"/pyspark/common_utils.py"
# }}

# .......................................................
# s8s Spark batch config
# .......................................................

s8sSparkBatchConfig = {
    "pyspark_batch": {
        "main_python_file_uri": scoringScript,
        "python_file_uris": [ commonUtilsScript ],
        "args": batchScoringArguments,
        "jar_file_uris": [ bqConnectorJarUri ]
    },
    "runtime_config": {
        "container_image": containerImageUri
    },
    "environment_config":{
        "execution_config":{
            "service_account": umsaFQN,
            "subnetwork_uri": subnet
            },
        "peripherals_config": {
            "spark_history_server_config": {
                "dataproc_cluster": f"projects/{projectID}/regions/{region}/clusters/{phsServer}"
                }
            }
        }
}


# .......................................................
# DAG
# .......................................................

with models.DAG(
    airflowDAGName,
    schedule_interval=None,
    start_date = days_ago(2),
    catchup=False,
) as scoringDAG:
    customerChurnPredictionStep = DataprocCreateBatchOperator(
        task_id="Predict-Customer-Churn",
        project_id=projectID,
        region=region,
        batch=s8sSparkBatchConfig,
        batch_id=batchIDPrefix 
    )
    customerChurnPredictionStep 
