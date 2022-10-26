# Module 3: Create user managed service account and grant IAM roles
In the previous module, we enabled Google APIs and (optionally) updated Organization policies. In this module, we will - 
1. Create a user managed service account (UMSA)
2. Grant this UMSA, requisite permissions to GCP services ins cope for the lab
3. Grant ourselves impresonate permissions to run as the UMSA
4. Some GCP Data Analystics services in the lab need specific permissions granted to the underlying Google Managed Default Service accounts - we will grant those permissions. Wherever possible, we will use UMSA to provision services.

**Lab Module Duration:** <br>
< 5 minutes 


## 1. Copy iam.tf file to the Terraform root directory

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/iam.tf .
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
           
           ....iam.tf <---WE ARE HERE
           

```


## 3. Open the file and read its contents
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/iam.tf
```

## 4. What it does ...
a) It first creates a user managed service account (UMSA),
b) It then grants the UMSA IAM roles
c) It also grants Google Managed Service accounts for specific services, roles as required by the services
d) It then grants the admin user impersonation privileges on the UMSA
e) For the rest of the lab, all services will be provisioned as the UMSA

## 4. Know this...
Terraform will run every .tf file in the root directory when an "apply" is issued. So, we jjst need to run "terraform apply" again

## 5. Execute "terraform apply"
Run "terraform apply" command you ran previously again and observe the output
 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```

## 6. Why the "terraform init" yet again?
If there is a new terraform provide(product/service), terraform will ask you to init again, so it can do its thing...<br>
In the end, you should see-
 ```
 Apply complete! Resources: 42 added, 0 changed, 0 destroyed.
 ```
 
## 7. Validate the provisioning
Go to Cloud Console -> IAM and make sure everything got created, in comparison to the declarations in iam.tf
 
<hr>


 This concludes the module. Please proceed to the [next module](Module-04.md).

<hr>


