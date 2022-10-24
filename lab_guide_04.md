### 8. IAM: Creation of user managed service account and IAM role granting

1. Move the file iam.tf as shown below to the Terraform root directory
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/iam.tf .
```
2. Open the file and read its contents
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/iam.tf
```
a) It first creates a user managed service account (UMSA),
b) It then grants the UMSA IAM roles
c) It also grants Google Managed Service accounts for specific services, roles as required by the services
d) It then grants the admin user impersonation privileges on the UMSA
e) For the rest of the lab, all services will be provisioned as the UMSA
 
3. Terraform will run every .tf file in the root directory when an "apply" is issued.
4. Run "terraform apply" command you ran previously again and observe the output
 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
In the end, you should see-
 ```
 Apply complete! Resources: 42 added, 0 changed, 0 destroyed.
 ```
 
5. We ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.
6. Validate the provisioning by going to Cloud Console -> IAM 
 
<hr>

### 9. Networking: Creation of VPC, Subnet, Firewall rule(s), reservered IP, VPC peering
 
In this section, we will provision networking entities needed for VPC native services/those that support BYO VPC - such as Cloud Dataproc, Cloud Composer, Cloud Dataflow, Vertex AI Workbench. <br>
 
1. Move the file network.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/network.tf .
```

2. Run the terraform<br> 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
3. While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/network.tf
```
a) It first creates VPC,<br>
b) And a subnet with Private Google Access<br>
c) It creates a specific firewall rule<br>
d) It creates a reserved IP needed for Vertex AI workbench, for BYO network<br>
e) It creates peers the network with the Google tenant network - again, needed for Vertex AI workbench, for BYO network<br>
 
4. Terraform will incrementally run every .tf file in the root directory and any updates to teh same when an "apply" is issued. It will therefore run the network.tf<br>
5. Observe the output in the other tab<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
 ```
 
6. We ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.
7. Validate the provisioning by going to Cloud Console -> Networking 
 
<hr>
 
### 10. Storage: Creation buckets
 
In this section, we will provision GCS buckets for Spark, dataproc, code, data, notebooks. <br>
 
1. Copy the file storage.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/storage.tf .
```

2. Run the terraform<br> 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
3. While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/storage.tf
```
It creates the various buckets<br>
 
4. Terraform will incrementally run every .tf file in the root directory and any updates to the same when an "apply" is issued. It will therefore run the network.tf<br>
 
5. In the end, you should see-<br>
 ```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
 ```
 
6. We ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.
7. Validate the provisioning by going to Cloud Console -> Storage
8. Here is the author's listing of buckets created-
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
 
### 12. BigQuery: Create dataset, table, load a CSV
 
In this section, we will create a .
 
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
