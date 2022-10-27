# Module 9: Create a Dataproc Metastore Service
 
In this section, we will create a Dataproc Metastore Service - managed Apache Hive Metastore, commonly used with Open Data Analytics services. 
This service can be used with Dataproc and Dataplex.<br>


**Lab Module Duration:** <br>
~ < 30 minutes 

<hr>

## 1. Copy the TF file for Dataproc Metastore Service into the Terraform root directory
Copy the file dpms.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/dpms.tf .
```

<hr>

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
  
           ....dpms.tf <--- WE ARE HERE
```

<hr>

## 3. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
 <hr>
 
## 4. Study the terraform
In a separate Cloud Shell tab-
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/dpms.tf
```


It first creates a Dataproc Metastore and uses a bucket if specified, and uses the subnet specified.<br>
Observe the output.<br>
Upon completion, you should see-<br>
 ```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
 ```
 
## 5. Validate 
Validate the provisioning by going to Cloud Console -> Dataproc<br>

Run through these steps in the Dataproc GUI<br>
a) Click on "Metastore" in the left navigation panel<br>
b) Review the deployment<br>


<hr>

 This concludes the module. Please proceed to the [next module](Module-10.md).

<hr>
