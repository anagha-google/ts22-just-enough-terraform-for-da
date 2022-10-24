### 12. BigQuery: Create dataset, table, load a CSV
 
In this section, we will create a BigQuery dataset, and also load a CSV file into a table that gets created automatically, via a BQ load job.
 
1. Copy the file bigquery.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/bigquery.tf .
```

2. Run the terraform<br> 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
3. While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/bigquery.tf
```
a) It first creates a BigQuery dataset<br>
b) And then creates a table off of a CSV file in GCS and loads the contents of the CSV file into it
 
4. Observe the output.<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
 ```
 
6. Once again, we ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.

7. Validate the provisioning by going to Cloud Console -> BigQuery

8. You can query the table created, in the BigQuery console-
<br>

```
SELECT * FROM `ts22_tf_lab_ds.us_states` LIMIT 6
```

<hr>
