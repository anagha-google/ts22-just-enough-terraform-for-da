
 ### 11. Storage Objects Upload: Upload scripts (pyspark, airflow, bash), data, notebooks (pyspark and python) to GCS
 
In this section, we will upload objects in sub-directories (01-data, 02-scripts, 03-notebooks) to corresspoding GCS buckets. <br> Within scripts - we will upload objects to three different sub-directories (pyspark, airflow, bash) and within notebooks, to python and pyspark sub-directories.
 
1. Copy the file storage.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/storage-objects.tf .
```

2. Run the terraform<br> 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
3. While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/storage-objects.tf
```
a) It first creates sub-directories in GCS buckets<br>
b) And then incrementally uploads the files locally to the corresspoding destination directory in the GCS buckets
 
4. Observe the output.<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
 ```
 
6. Once again, we ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.
7. Validate the provisioning by going to Cloud Console -> Storage
8. Here is the author's listing of buckets created-
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
 
