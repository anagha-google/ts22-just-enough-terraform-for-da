# Module 14: Customize a file with Terraform
Often we need to customize files before running them, based on variables unique to the deployment. In this module, we will customize our Vertex AI Workbench notebook instance post startup scripts at Terraform runtime. <br>

**Lab Module Duration:** <br>
5 minutes or less 


## 1. Copy the TF file for customizing scripts into the Terraform root directory
Copy the file customize_scripts.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/customize-scripts.tf .
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
           ....bash.tf
           
           ....customize-scripts.tf<--- We are here
```

## 3. Noteworthy artifacts

```
~/ts22-just-enough-terraform-for-da
         00-setup 
         01-datasets
         02-scripts
         03-notebooks
         
         04-templates
           ....mnbs-exec-post-startup.sh
           ....umnbs-exec-post-startup.sh
         
         05-lab-guide
         README.md
```

## 4. Review the each of the bash scripts

4.1. Review the script - mnbs-exec-post-startup.sh
```
cat  ~/ts22-just-enough-terraform-for-da/04-templates/mnbs-exec-post-startup.sh
```

Its a simple script that copies GCS directory contents to a a Workbench notebook instance directory and changes permissions.
```
#........................................................................
# Purpose: Copy existing notebooks to Workbench server Jupyter home dir
# (Managed notebook server)
#........................................................................

gsutil cp gs://ts22-jetfdc_notebook_bucket-YOUR_PROJECT_NBR/pyspark/*.ipynb /home/jupyter/
chown jupyter:jupyter /home/jupyter/*
```

4.2. Review the script - umnbs-exec-post-startup.sh

```
cat  ~/ts22-just-enough-terraform-for-da/04-templates/umnbs-exec-post-startup.sh
```

Its also a simple script that copies GCS directory contents to a a Workbench notebook instance directory and changes permissions.

## 5. Review customize-scripts.tf
1. It merely uses "sed" to replace "YOUR_PROJECT_NBR" to an actual project number based off of the var.project_nbr
2. And then copies the file to GCS code bucket, bash directory

## 6. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
## 7. Study the Terraform output
Observe the output. You should not see any errors.
 
## 8. Validate the execution of the script

Go to GCS and look up the files - they should not have the keyword 'YOUR_PROJECT_NUMBER' in them, and should have your actual project number substituted.

<br>
8.1. Validate the substitution in the Post Startup Script for Managed Notebook Instance:

```
PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
gsutil cat gs://ts22-jetfdc_code_bucket-${PROJECT_NBR}/bash/mnbs-exec-post-startup.sh
```

<br>

8.2. Validate the substitution in the Post Startup Script for User Managed Notebook Instance:

```
PROJECT_ID=`gcloud config list --format "value(core.project)" 2>/dev/null`
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
gsutil cat gs://ts22-jetfdc_code_bucket-${PROJECT_NBR}/bash/umnbs-exec-post-startup.sh
```


<hr>

 This concludes the module. Please proceed to the [next module](Module-15.md).

<hr>
