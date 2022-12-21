# Module 20: (Optional) Run this lab in one shot

You can run the who lab in one shot if all the .tf files in the shelf directory of 00-setup were in the Terraform root directory. Terraform will review the files and do the necessary dependency management as specified in the individual GCP service specific deployment declaration.

**Note**: You need a project pre-created for this module. 

<hr>

## 1. Clone this repo in Cloud Shell scoped to the project you created for the lab

```
cd ~
git clone https://github.com/anagha-google/ts22-just-enough-terraform-for-da.git
cd ts22-just-enough-terraform-for-da
```

<hr>

## 2. Edit the preferences script & run it

2.1. Open the script configure-preferences.sh and review it
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/configure-preferences.sh
```

2.2. Edit to customize your region. No change is needed if you are okay with running in us-central region.

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


2.3. Run it-
```
cd ~/ts22-just-enough-terraform-for-da/00-setup
./configure-preferences.sh
```

<hr>

## 3. Run the foundational Terraform module

This just enables Google APIs and (optionally) updates the org policies, and effectively executes the module - module_apis_and_policies/main.tf in the Terrafrom root directory ~/ts22-just-enough-terraform-for-da/00-setup. All resources created in the lab depend on the successful completion of this Terraform module.


```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```

This could take ~5 minutes to complete.

With this output-
```
Apply complete! Resources: xx added, 0 changed, 0 destroyed.
```

<hr>

## 4. Copy the .tf in shelf/ to the Terraform root directory

Run the below in cloud shell. What this does is copy all the terraform templates for individual GCP Data Analytics services into the Terraform root directory, so that we can provision them in one shot.

```
cd ~/ts22-just-enough-terraform-for-da/00-setup
cp -r shelf/* .
```

<hr>

## 5. Provision Data Analytics services

Run the below from the Terraform root directory in Cloud Shell.

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/

terraform init

terraform plan

terraform apply --auto-approve
```

This could take ~65 minutes to complete.

You should see this this output-
```
Apply complete! Resources: xx added, 0 changed, 0 destroyed.

Outputs:
CLOUD_COMPOSER_DAG_BUCKET = "gs://us-central1-ts-22-tf-lab-cc-XXXXX-bucket/dags"
```


## 6. Review of what we provisioned and validations

Start reading the lab guides from Module 1 to get a sound understanding and also validate the successful provisioning.
<br>
E.g. <br>
GCS buckets created<br>
Objects copied to buckets<br>
Dataproc cluster created...<br>

## 7. Dont forget to
Shut down the project or run "terraform destroy" to stop the billing.

<hr>
This concludes the lab.
<hr>




