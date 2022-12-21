
# Module 11: (Optional) Run a PySpark notebook on Dataproc Cluster on GCE on a BigLake table
 
In the prior module we created a Dataproc cluster with Jupyter enabled as an optional component, and we uploaded a notebook to the specific GCS path where Jupyter on Dataproc can recognize and make available.<br>

In this module, we will run the notebook, just for the experience of running a Spark notebook in Dataproc on GCE.<br>
The notebook does Icecream Sales Forecasting on a BigLake table.<br> 


**Lab Module Duration:** <br>
- (optional) Ice cream sales forecasting notebook - 5 minutes

## 1. Optional: Run the PySpark Icecream Sales Forecasting notebook
a) On Cloud Console, navigate to the Dataproc UI
b) Click on your cluster (has the keyword dpgce)
c) Go to Web Interfaces in the horizontal menu
d) In the "Web Interfaces" page Click on "JupyterHub".<br>
e) Click on the notebook that opens up and execute the notebook. <br>
f) It reads a Biglake table featuring icecream sales and does sales forecasting using the ML library Prophet. If you recall, we create a router and NAT to allow download of libraries from PyPi in the network module<br>

<hr>


 This concludes the module. Please proceed to the [next module](Module-12.md).
=======
# Module 11: (Optional) Run a Serverless Spark batch job

This is an optional module and merely serves as smoke-testing for Dataproc Servreless Spark provisioning. You can skip this and move to the next module, as needed.

**Lab Module Duration:** <br>
- (optional) Chicago Crimes Analytics - 5 minutes

## 1. Copy the TF file for Dataproc Cluster on GCE into the Terraform root directory
Copy the file dpgce.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/dpgce.tf .
```

## 2. Layout of the Terraform root directory
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


This concludes the module. Please proceed to the [next module](Module-12.md).



<hr>
