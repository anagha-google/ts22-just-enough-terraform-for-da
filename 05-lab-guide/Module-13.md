# Module 13: Run a shell script
 
In this module, we will run a very basic shell script that create a file and persist it to a GCS bucket.<br>

**Lab Module Duration:** <br>
5 minutes or less 


## 1. Copy the TF file for bash into the Terraform root directory
Copy the file bash.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/bash.tf .
```

## 2. Layout of the Terraform root directory
```
~/ts22-just-enough-terraform-for-da/00-setup

           ....module_apis_and_policies
           ....shelf

           ....main.tf
           ....variables.tf
           ....versions.tf
           ....terraform.tfvars 
           
           ....iam.tf
           ....network.tf    
           ....storage.tf 
           ....bigquery.tf
           ....phs.tf 
           ....dpms.tf
           ....dpgce 
           
           ....bash.tf<--- We are here

```

## 3. Noteworthy artifacts

```
~/ts22-just-enough-terraform-for-da
         00-setup
           
         01-datasets
           
         02-scripts
             ....airflow/
             
             ....bash/
               hello_world_bash_sample.sh
         
         03-notebooks
         04-templates
         05-lab-guide
         README.md
```

## 4. Review the bash script
```
cat  ~/ts22-just-enough-terraform-for-da/02-scripts/bash/hello_world_bash_sample.sh
```

Its a simple script that accepts some parameters and create a file that it persists to a GCS location submitted as an argument.

```
cat hello_world_bash_sample.sh
#!/bin/bash

#........................................................................
# Purpose: Demonstrate how to run a bash script from Terraform
# About:
# The script creates a local file based on the arguments and uploads
# the file to GCS
#........................................................................

# Variables
PROJECT_ID=`gcloud config list --format 'value(core.project)'`
GCP_ACCOUNT_NAME=$1
GCP_REGION=$2
TARGET_GCS_BUCKET_URI=$3

echo "Hello ${GCP_ACCOUNT_NAME}, from ${GCP_REGION}" > dummy.txt
gsutil cp dummy.txt $TARGET_GCS_BUCKET_URI
```


## 5. Run the script manually

```
PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
REGION=us-central1 #Edit if your region is different
UMSA_FQN="ts22-jetfdc-lab-sa@${PROJECT_ID}.iam.gserviceaccount.com"


cd ~/ts22-just-enough-terraform-for-da/02-scripts/bash/
chmod +x hello_world_bash_sample.sh
./hello_world_bash_sample.sh $UMSA_FQN $REGION "gs://ts22-jetfdc-spark-bucket-${PROJECT_NBR}/dummy/"
```

Review the result-
```
PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`

gsutil cat gs://ts22-jetfdc-spark-bucket-${PROJECT_NBR}/dummy/dummy.txt
```

Author's result-
```
Hello ts22-jetfdc-lab-sa@ts22-lab.iam.gserviceaccount.com, from us-central1
```


## 6. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
## 7. Study the Terraform output
Observe the output and watch for errors.
 
## 8. Validate the execution of the script

Results should be the same as #5 above

<hr>

 This concludes the module. Please proceed to the [next module](Module-14.md).

<hr>
