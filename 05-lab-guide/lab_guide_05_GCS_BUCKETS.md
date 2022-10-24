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
 
