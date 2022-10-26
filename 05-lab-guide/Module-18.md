# Module 18: Provision Cloud Composer
In this module- 
1. We will provision Cloud Composer 2 
2. and pass an environment variable as part of our terraform
3. and capture the composer DAG bucket output into a variable
4. and then upload a "Hello World" DAG to the DAG bucket
5. Finally, we will run the DAG from the GUI
<br>

**Lab Module Duration:** <br>
25 minutes


## 1. Copy the TF file for Cloud Composer into the Terraform root directory
Copy the file composer.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/composer.tf .
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
           ....dpgce
           ....bash.tf
           ....customize-scripts.tf
           ....vertex-ai.tf
           
           ....composer.tf<--- We are here
```

## 3. Noteworthy artifacts

```
~/ts22-just-enough-terraform-for-da
         00-setup/
           ....composer.tf
           
         01-datasets
         02-scripts
           ....airflow/
               ....pipeline.py
               
         03-notebooks/
         04-templates        
         05-lab-guide
         README.md
```

## 4. Conditional provisioning
vertex-ai.tf is different from the .tf files we have run so far. It optionally provisions Vertex AI services, based on the boolean value below in the configure_preferences.sh script we ran in Module-01, which is persisted to terraform.tfvars.<br>

Lets review what we configured-
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cat terraform.tfvars | grep vertex
```

Here is the author's output-
```
provision_vertex_ai_bool = "true"
```

### 5. Review the vertex-ai.tf

Review the file 


## 6. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
## 7. Study the Terraform output
Observe the output. You should not see any errors.
 
## 8. Validate the execution of the script

### 8.1. Validate creation of Managed Notebook instance
1. Go to the cloud console and open Vertex AI and click on Vertex AI Workbench.
2. Click on the "Managed Notebook" tab
3. Click on the instance
4. Launch JupyterLab
5. You should see a notebook - Chicago Crimes
6. Open the notebook, and click save. You should be able to save successfully

### 8.2. Validate creation of User Managed Notebook instance
Next-
1. Click on the Vertex AI Workbench -> "User Managed Notebook" tab
2. Click on the instance
3. Launch JupyterLab
4. You should see a notebook - Google Trends
5. Open the notebook, and click save. You should be able to save successfully


<hr>

This concludes the module. Proceed to the next module.

<hr>
