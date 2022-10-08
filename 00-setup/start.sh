PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
PROJECT_NAME=`gcloud projects describe ${PROJECT_ID} | grep name | cut -d':' -f2 | xargs`
GCP_ACCOUNT_NAME=`gcloud auth list --filter=status:ACTIVE --format="value(account)"`
ORG_ID=`gcloud organizations list --format="value(name)"`
VPC_NM=s8s-vpc-$PROJECT_NBR
SPARK_SERVERLESS_SUBNET=spark-snet
PERSISTENT_HISTORY_SERVER_NM=s8s-sphs-${PROJECT_NBR}
UMSA_FQN=s8s-lab-sa@$PROJECT_ID.iam.gserviceaccount.com
DATA_BUCKET=s8s_data_bucket-${PROJECT_NBR}
CODE_BUCKET=s8s_code_bucket-${PROJECT_NBR}
MODEL_BUCKET=s8s_model_bucket-${PROJECT_NBR}
BQ_CONNECTOR_JAR_GCS_URI="gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.22.2.jar"
CLOUD_COMPOSER_IMG_VERSION="composer-2.0.11-airflow-2.2.3"
SPARK_CUSTOM_CONTAINER_IMAGE_TAG="1.0.0"
YOUR_GCP_REGION="us-central1"
YOUR_GCP_ZONE="us-central1-a"
YOUR_GCP_MULTI_REGION="US"
CLOUD_SCHEDULER_TIME_ZONE="America/Chicago"

echo "project_id = "\"$PROJECT_ID"\"" > terraform.tfvars
echo "project_number = "\"$PROJECT_NBR"\"" >> terraform.tfvars
echo "project_name = "\"$PROJECT_NAME"\"" >> terraform.tfvars
echo "gcp_account_name = "\"${GCP_ACCOUNT_NAME}"\"" >> terraform.tfvars
echo "org_id = "\"${ORG_ID}"\"" >> terraform.tfvars
echo "cloud_composer_image_version = "\"${CLOUD_COMPOSER_IMG_VERSION}"\"" >> terraform.tfvars
echo "spark_container_image_tag = "\"${SPARK_CUSTOM_CONTAINER_IMAGE_TAG}"\"" >> terraform.tfvars
echo "gcp_region = "\"${YOUR_GCP_REGION}"\"" >> terraform.tfvars
echo "gcp_zone = "\"${YOUR_GCP_ZONE}"\"" >> terraform.tfvars
echo "gcp_multi_region = "\"${YOUR_GCP_MULTI_REGION}"\"" >> terraform.tfvars
echo "bq_connector_jar_gcs_uri = "\"${BQ_CONNECTOR_JAR_GCS_URI}"\"" >> terraform.tfvars
echo "cloud_scheduler_time_zone = "\"${CLOUD_SCHEDULER_TIME_ZONE}"\"" >> terraform.tfvars 

