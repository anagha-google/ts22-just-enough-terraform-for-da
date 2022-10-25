# Module 12: (Optional) Run a Serverless Spark batch job

This is an optional module and merely serves as smoke-testing for Dataproc Servreless Spark provisioning. You can skip this and move to the next module, as needed.

**Lab Module Duration:** <br>
5 minutes or less

## 1. Run the SparkPi batch job on Cloud Shell


```
PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
REGION=us-central #Edit if your region is different
SUBNET=ts22-jetfdc-snet
HISTORY_SERVER_NAME="ts22-jetfdc-sphs-${PROJECT_NBR}"
UMSA_FQN="ts22-jetfdc-lab-sa@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud dataproc batches submit \
 --project ${PROJECT_ID} \
 --region ${REGION} \
  spark --batch $NAME-sparkpi-${RANDOM} \
  --class org.apache.spark.examples.SparkPi \
  --jars file:///usr/lib/spark/examples/jars/spark-examples.jar  \
  --subnet ${SUBNET} \
  --service-account ${UMSA}@${PROJECT_ID}.iam.gserviceaccount.com \
  --history-server-cluster projects/${PROJECT_ID}/regions/${REGION}/clusters/${HISTORY_SERVER_NAME}
```

## 2. View the results in the Dataproc Serverless Spark Batches UI




<hr>

This concludes the module. Proceed to the next module.

<hr>
