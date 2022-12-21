# Module 18: Provision Cloud Composer
In this module- 
1. We will provision Cloud Composer 2 
2. and pass an environment variable as part of our terraform
3. and capture the composer DAG bucket output into a variable
4. and then upload a "Hello World" DAG to the DAG bucket
5. Finally, we will run the DAG from the GUI
<br>

**Lab Module Duration:** <br>
25 minutes


## 1. Copy the TF file for Cloud Composer into the Terraform root directory
Copy the file composer.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/composer.tf .
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
           ....customize-scripts.tf
           ....vertex-ai.tf
           
           ....composer.tf<--- We are here
```

## 3. Noteworthy artifacts

```
~/ts22-just-enough-terraform-for-da
         00-setup/
           ....composer.tf
           
         01-datasets
         02-scripts
           ....airflow/
               ....pipeline.py
               
         03-notebooks/
         04-templates        
         05-lab-guide
         README.md
```

## 4. Review the TF file

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cat composer.tf
```
1. We will provision Cloud Composer 2 
2. and pass an environment variable as part of our terraform
3. and capture the composer DAG bucket output into a variable
4. and then upload a "Hello World" DAG -> ../02-scripts/airflow/pipeline.py to the DAG bucket


### 5. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
## 7. Study the Terraform output
Observe the output. You should not see any errors.
 
## 8. Validate the provisioning
Takes ~25 minute to provision. Run through these steps post provisioning-

1. Go to Cloud Composer 2 and click on the instance provisioned.
2. Click on Environment Variables tab and check for a variable called AIRFLOW_GCP_ACCOUNT_NAME and check if it has your ID
3. Open the DAG bucket and check for pipeline.py to ensure if got uploaded
4. Next, open the Airflow UI
5. You should see the DAG "composer_sample_simple_greeting"
6. Run the DAG
7. After it completes, click on the logs look for the greeting in the logs


<hr>

This concludes the lab. Please proceed to the [next module](Module-19.md) where you will learn to destroy the environment.

<hr>
