# Module 7: Create BigQuery objects
 
In this section, we will create a dataset, managed table, biglake table, run a load job

**Lab Module Duration:** <br>
5 minutes 


## 1. Copy the TF file for BigQuery into the Terraform root directory
Copy the file bigquery.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/bigquery.tf .
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
           
           ....bigquery.tf<--- WE ARE HERE
           
```

## 3. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
## 4. Study the terraform
In a separate Cloud Shell tab-
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/bigquery.tf
```

a) It first creates a BigQuery dataset<br>
b) And then creates a table called us_states_managed_table off of a CSV file in GCS and loads the contents of the CSV file into it
c) Then creates an external connection
d) And then a biglake table called icecream_sales_biglake_table


## 5. Study the Terraform output
Observe the output.<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

## 6. Validate the provisioning by going to Cloud Console -> BigQuery

1. You can query the managed table created, in the BigQuery console-
<br>

```
SELECT * FROM ts22_tf_lab_ds.us_states LIMIT 6
```

2. You can quey the BigLake table created -
<br>

```
SELECT * FROM ts22_tf_lab_ds.icecream_sales_biglake_table LIMIT 1000
```

<hr>

 This concludes the module. Please proceed to the [next module](Module-08.md).

<hr>

