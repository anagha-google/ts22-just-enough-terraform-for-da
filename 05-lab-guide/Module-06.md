
 # 6. Upload objects to Cloud Storage
 
In this section, we will upload objects in sub-directories (01-data, 02-scripts, 03-notebooks) to corresspoding GCS buckets. <br> Within scripts - we will upload objects to three different sub-directories (pyspark, airflow, bash) and within notebooks, to python and pyspark sub-directories.

**Lab Module Duration:** <br>
5 minutes 


## 1. Copy the TF file for storage objects into the Terraform root directory
Copy the file storage-objects.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/storage-objects.tf .
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
           ....storage-objects.tf <--- We are here
 ```

## 3. Artifacts to upload to GCS buckets

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
 
## 5. Review the content of the Terraform script
While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/storage-objects.tf
```
a) It first creates sub-directories in GCS buckets<br>
b) And then incrementally uploads the files locally to the corresspoding destination directory in the GCS buckets
 
## 6. Observe the output
In the end, you should see-<br>
 ```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
 ```
 
## 7. Validate
Validate the provisioning by going to Cloud Console -> Storage<br>

Here is the author's listing of buckets created-
<br>
**Scripts bucket**: Author's output-
```
gsutil ls -r gs://ts22-jetfdc_code_bucket-1053039281529/
```
 
```
gs://ts22-jetfdc_code_bucket-1053039281529/airflow/:
gs://ts22-jetfdc_code_bucket-1053039281529/airflow/pipeline.py

gs://ts22-jetfdc_code_bucket-1053039281529/bash/:
gs://ts22-jetfdc_code_bucket-1053039281529/bash/hello_world_bash_sample.sh

gs://ts22-jetfdc_code_bucket-1053039281529/pyspark/:
gs://ts22-jetfdc_code_bucket-1053039281529/pyspark/chicago_crime_analysis.py
 ```
**Data bucket**: Author's output-
```
gsutil ls -r gs://ts22-jetfdc_data_bucket-1053039281529/
```
 
```
gs://ts22-jetfdc_data_bucket-1053039281529/IceCreamSales.csv
gs://ts22-jetfdc_data_bucket-1053039281529/Plant_Boundaries.csv
 ```
**Notebook bucket**: Author's output- 
```
gsutil ls -r gs://ts22-jetfdc_notebook_bucket-1053039281529/
```
 
``` 
gs://ts22-jetfdc_notebook_bucket-1053039281529/pyspark/:
gs://ts22-jetfdc_notebook_bucket-1053039281529/pyspark/IceCream.ipynb
gs://ts22-jetfdc_notebook_bucket-1053039281529/pyspark/IceCreamSales.csv
gs://ts22-jetfdc_notebook_bucket-1053039281529/pyspark/chicago-crimes-analytics.ipynb

gs://ts22-jetfdc_notebook_bucket-1053039281529/python/:
gs://ts22-jetfdc_notebook_bucket-1053039281529/python/google_trends_analysis.ipynb
```
 
<hr>

 This concludes the module. Please proceed to the [next module](Module-07.md).

<hr>
 
