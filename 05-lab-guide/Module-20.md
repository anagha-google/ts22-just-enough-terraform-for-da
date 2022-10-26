# Module 20: (Optional) Run this lab in one shot

You can run the who lab in one shot if all the .tf files in the shelf directory of 00-setup were in the Terraform root directory. Terraform will review the files and do the necessary dependency management as specified in the individual GCP service specific deployment declaration.

<hr>

## 1. Clone this repo in Cloud Shell

```
cd ~
git clone https://github.com/anagha-google/ts22-just-enough-terraform-for-da.git
cd ts22-just-enough-terraform-for-da
```

<hr>

## 2. Copy the .tf in shelf/ to the Terraform root directory

Run the below in cloud shell
```
cd ~/ts22-just-enough-terraform-for-da/00-setup
cp -r shelf/* .
```

<hr>

## 3. Edit the preferences script & run it

3.1. Open the script configure-preferences.sh and review it
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/configure-preferences.sh
```



3.2. Edit to customize your region. No change is needed if you are okay with running in us-central region.

```
cd ~/ts22-just-enough-terraform-for-da/00-setup
vi configure-preferences.sh
```

What's in the script
```
PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
PROJECT_NAME=`gcloud projects describe ${PROJECT_ID} | grep name | cut -d':' -f2 | xargs`
GCP_ACCOUNT_NAME=`gcloud auth list --filter=status:ACTIVE --format="value(account)"`
ORG_ID=`gcloud organizations list --format="value(name)"`
BQ_CONNECTOR_JAR_GCS_URI="gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.22.2.jar"
CLOUD_COMPOSER_IMG_VERSION="composer-2.0.29-airflow-2.2.5"
YOUR_GCP_REGION="us-central1"
YOUR_GCP_ZONE="${YOUR_GCP_REGION}-a"
YOUR_GCP_MULTI_REGION="US"
PROVISION_VERTEX_AI="true"
UPDATE_ORG_POLICIES="true"
```

Where you can make changes is-
1. YOUR_GCP_REGION and YOUR_GCP_MULTI_REGION for your regional preferences
2. UPDATE_ORG_POLICIES boolean if you dont need org policy updates
3. PROVISION_VERTEX_AI boolean if you want to skip the Vertex AI modules


3.3. Run it-
```
cd ~/ts22-just-enough-terraform-for-da/00-setup
./configure-preferences.sh
```

<hr>

## 4. Run the Terraform scripts
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```

This could take ~1 hour to complete.

With this output-
```
Apply complete! Resources: 107 added, 0 changed, 0 destroyed.

Outputs:

CLOUD_COMPOSER_DAG_BUCKET = "gs://us-central1-ts-22-tf-lab-cc-XXXXX-bucket/dags"
```

<hr>

## 5. Dont forget to
Shut down the project or run "terraform destroy" to stop the billing.

<hr>
This concludes the lab.
<hr>
