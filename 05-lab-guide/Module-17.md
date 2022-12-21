# Module 17: (Optional) Run a PySpark Notebook (Chicago Crimes Analysis) on the Managed Notebook instance on Vertex AI Workbench 



## THIS IS A PREVIEW FEATURE (OCT 2022) AND NEEDS ALLOW_LISTING.<br><br>

This module is not Terraform related. In module 15, we created a Managed Notebook instance on Vertex AI Workbench and uploaded a Chicago Crimes notebook to the instance as part of a post startup script. In this module, we will just run the notebook to learn how to run Dataproc Serverless Spark on Managed Notebooks. This module is entirely optional.

**Lab Module Duration:** <br>
10 minutes or less 

## 1. Create an interactive Dataproc Serverless Spark session from Cloud Shell

Run the below in Cloud Shell-
```
PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
SESSION_NAME="chicago-crimes"
LOCATION="us-central1"
SUBNET="ts22-jetfdc-snet"
UMSA_FQN="ts22-jetfdc-lab-sa@${PROJECT_ID}.iam.gserviceaccount.com"


gcloud beta dataproc sessions create spark $SESSION_NAME-$RANDOM  \
--project=${PROJECT_ID} \
--location=${LOCATION} \
--property=spark.jars.packages="com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2" \
--service-account="${UMSA_FQN}" \
--version 2.0 \
--subnet=$SUBNET 

```

## 2. Open the Chicago Crimes notebook

1. Click on the Vertex AI Workbench -> "Managed Notebook" tab
2. Click on the instance
3. Launch JupyterLab
4. You should see a notebook - Chicago
5. Open the notebook, and click save. You should be able to save successfully
6. Click on the kernel picker and pick the session called "chicago-crimes"
7. Give it 5 seconds
8. Then run the notebook


<hr>

 This concludes the module. Please proceed to the [next module](Module-18.md).


<hr>
