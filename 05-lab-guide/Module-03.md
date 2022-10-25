# Module 3: Creation of user managed service account and IAM role granting
In the previous module, we enabled Google APIs and (optionally) updated Organization policies. In this module, we will - 
1. Create a user managed service account (UMSA)
2. Grant this UMSA, requisite permissions to GCP services ins cope for the lab
3. Grant ourselves impresonate permissions to run as the UMSA
4. Some GCP Data Analystics services in the lab need specific permissions granted to the underlying Google Managed Default Service accounts - we will grant those permissions. Wherever possible, we will use UMSA to provision services.


## Copy iam.tf file to the Terraform root directory

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/iam.tf .
```

Here is the layout of our Terraform root directory:<br>
```
~/ts22-just-enough-terraform-for-da
         00-setup
           ....main.tf
           ....variables.tf
           ....versions.tf
           ....terraform.tfvars 
           
           ....iam.tf <---WE ARE HERE
           
         01-datasets
         02-scripts
         03-notebooks
         04-templates
         05-lab-guide
         README.md
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

