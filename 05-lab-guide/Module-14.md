# Module 13: Customize a file
Often we need to custmize files before running them, based on variables unique to the dpeloyment. In this module, we will customize our Vertex AI Workbench notebook instance startup scripts at Terraform runtime. <br>

**Lab Module Duration:** <br>
5 minutes or less 


## 1. Copy the TF file for customizing scripts into the Terraform root directory
Copy the file customize_scripts.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/customize_scripts.tf .
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
           
           ....customize_scripts.tf<--- We are here
```

## 3. Noteworthy artifacts

```
~/ts22-just-enough-terraform-for-da
         00-setup 
         01-datasets
         02-scripts
         03-notebooks
         
         04-templates
           ....mnbs-exec-post-startup.sh
           ....umnbs-exec-post-startup.sh
         
         05-lab-guide
         README.md
```

## 4. Review the one of the bash scripts
```
cat  ~/ts22-just-enough-terraform-for-da/04-templates/mnbs-exec-post-startup.sh
```

Its a simple script that accepts copies GCS directory contents to a directory and changes permissions.
```
#........................................................................
# Purpose: Copy existing notebooks to Workbench server Jupyter home dir
# (Managed notebook server)
#........................................................................

gsutil cp gs://ts22-jetfdc_notebook_bucket-YOUR_PROJECT_NBR/pyspark/*.ipynb /home/jupyter/
chown jupyter:jupyter /home/jupyter/*
```

## 5. Review customize_scripts.tf
1. It merely uses "sed" to replace "YOUR_PROJECT_NBR" to an actual project number based off of the var.project_nbr
2. And then copies the file to GCS

## 6. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
## 7. Study the Terraform output
Observe the output.<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
 ```
 
## 8. Validate the execution of the script

Go to GCS and look up the files.


<hr>

This concludes the module. Proceed to the next module.

<hr>
