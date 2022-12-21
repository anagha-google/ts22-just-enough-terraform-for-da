# Module 10: Create a Dataproc Cluster on GCE
 
In this module, we will create a Dataproc Cluster on GCE, otherwise referred to as DPGCE.<br>

This cluster uses the Dataproc Metastore Service from the previous module as its Apache Hive Metastore, uses the network, subnet, router and NAT. 
Router and NAT to download from PyPi, Prophet for forecasting in the lab Jupyter notebook, covered in Module 11.

**Lab Module Duration:** <br>
- Terraform - 5 minutes 


## 1. Copy the TF file for Dataproc Cluster on GCE into the Terraform root directory
Copy the file dpgce.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/dpgce.tf .
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
           
           ....dpgce <--- We are here

```

## 3. Noteworthy artifacts

```
~/ts22-just-enough-terraform-for-da
         00-setup
           ....main.tf
           ....variables.tf
           ....versions.tf
           ....terraform.tfvars 
           
           ....iam.tf 
           
           
           ..dpgce.tf <--- Terraform script
           
         01-datasets
           ....ice_cream_sales.csv <--- Source of BigLake table
           
         02-scripts
         
         03-notebooks
           ....pyspark/
               ....icecream-sales-forecasting.ipynb <--- Notebook for sales forecasting on BigLake table
         
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
cat ~/ts22-just-enough-terraform-for-da/00-setup/dpgce.tf
```
a) It first creates a Dataproc cluster and uses a bucket specified, uses the subnet created.<br>
b) It copies a PySpark notebook into an exact location expected by JupyterLab on DPGCE


## 6. Study the Terraform output
Observe the output.<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
 ```
 
## 6. Validate the provisioning by going to Cloud Console -> Dataproc

a) Click on "clusters" in the left navigation panel<br>
b) The DPGCE cluster has the keyword "dpgce" in it<br>
c) Review the features of the cluster GUI<br>
d) Make sure JupyterLa is enabled and can be opened. We will use a notebook in the next module.<br>


<hr>

 This concludes the module. Please proceed to the [next module](Module-11.md).

<hr>

## Bonus:
Here is the gcloud equivalent of what we just did via Terraform:

```
Blah


```
