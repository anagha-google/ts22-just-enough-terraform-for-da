# Module 10: Create a Dataproc Cluster on GCE
 
In this module, we will create a Dataproc Cluster on GCE, otherwise referred to as DPGCE and (optionally) do Icecream Sales Forecasting on a BigLake table.<br> 

This cluster uses the Dataproc Metastore Service from the previous module as its Apache Hive Metastore, uses the network, subnet, router and NAT. 
Router and NAT to download from PyPi, Prophet for forecasting in the lab Jupyter notebook.

**Lab Module Duration:** <br>
- Terraform - 3 minutes 
- (optional) Ice cream sales forecasting notebook - 5 minutes

## 1. Copy the TF file for Dataproc Cluster on GCE into the Terraform root directory
Copy the file dpgce.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/dpgce.tf .
```

## 2. Layout of the 
```
~/ts22-just-enough-terraform-for-da
         00-setup
           ....main.tf
           ....variables.tf
           ....versions.tf
           ....terraform.tfvars 
           
           ....iam.tf 
           
           
           ..dpgce.tf <--- WE ARE HERE
           
         01-datasets
         02-scripts
         03-notebooks
         04-templates
         05-lab-guide
         README.md
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
           
           
           ..dpgce.tf <--- WE ARE HERE
           
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

## 7. Optional: Run the PySpark Icecream Sales Forecasting notebook
d) Go to Web Interfaces, click on "JupyterHub".<br>
e) Click on the notebook that opens up and execute the notebook. <br>

<hr>

This concludes the module. Proceed to the next module.

<hr>
