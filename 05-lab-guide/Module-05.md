# Module 5. Cloud Storage buckets
 
In this section, we will provision GCS buckets for Spark, dataproc, code, data, notebooks. <br>

**Lab Module Duration:** <br>
5 minutes 


## 1. Copy the TF file for storage into the Terraform root directory
Copy the file storage.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/storage.tf .
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
                
           ....storage.tf <--- WE ARE HERE
           
```

## 3. Noteworthy artifacts

```
~/ts22-just-enough-terraform-for-da

         00-setup

         01-datasets/
           ....ice_cream_sales.csv <--- Source of BigLake table
           ....us_states.csv <---- Source of BigQuery managed table
           
         02-scripts/
           airflow/
              ....pipeline.py
                           
           bash/
             ....hello_world_bash_sample.sh
             
           
         
         03-notebooks
           pyspark/
             ....icecream-sales-forecasting.ipynb <--- Spark notebook for sales forecasting on BigLake table on Dataproc GCE
             ....chicago-crimes-analytics.ipynb   <--- Spark notebook for chicago crimes analytics on BQ table on Dataproc Serverless/Vertex AI managed notebooks
               
           python/
             ....google-trends-analysis.ipynb     <--- Python notebook for google trends analytics on BQ table on Vertex AI user-managed notebooks
             
         04-templates
         05-lab-guide
         README.md
```


## 4. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
## 5. Study the terraform
In a separate Cloud Shell tab-
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/storage.tf
```
It merely greates regional buckets.


## 6. Study the Terraform output
Observe the output.<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
 ```
 
## 6. Validate the provisioning by going to Cloud Console -> Cloud Storage

Here is the author's listing of buckets created-
 ```
gsutil ls
 
gs://ts22-jetfdc-spark-bucket-1053039281529/
gs://ts22-jetfdc-sphs-1053039281529/
gs://ts22-jetfdc_code_bucket-1053039281529/
gs://ts22-jetfdc_data_bucket-1053039281529/
gs://ts22-jetfdc_dataproc_bucket-1053039281529/
gs://ts22-jetfdc_notebook_bucket-1053039281529/
 ```

<hr>

This concludes the module. Proceed to the next module.

<hr>
 
